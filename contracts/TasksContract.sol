// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract TasksContract {
    uint256 public taskCounter;

    event TaskCreated(address recipent, uint256 taskId);

    event DeleteTask(uint256 taskId, bool isDeleted);

    event TaskToggleDone(uint256 id, bool done);

    struct Task {
        uint256 id;
        string title;
        string description;
        bool done;
        bool isDeleted;
        uint256 createdAt;
    }

    Task[] private tasks;

    mapping(uint256 => address) public taskToOwner;

    function createTask(string memory _title, string memory _description)
        public
    {
        uint256 taskId = tasks.length;

        tasks.push(
            Task(
                taskId,
                _title,
                _description,
                false,
                false,
                block.timestamp
            )
        );
        taskToOwner[taskId] = msg.sender;
        emit TaskCreated(msg.sender, taskId);
    }

    function getMyTasks() public view returns (Task[] memory) {
        Task[] memory temporary = new Task[](tasks.length);
        uint256 counter = 0;
        for (uint256 i = 0; i < tasks.length; i++) {
            if (taskToOwner[i] == msg.sender && tasks[i].isDeleted == false) {
                temporary[counter] = tasks[i];
                counter++;
            }
        }

        Task[] memory result = new Task[](counter);
        for (uint256 i = 0; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    function deleteTask(uint256 taskId, bool isDeleted) public {
        if (taskToOwner[taskId] == msg.sender) {
            Task memory _task = tasks[taskId];
            _task.isDeleted = isDeleted;
            tasks[taskId] = _task;
            emit DeleteTask(taskId, isDeleted);
        }
    }

    function toggleDone(uint256 _id) public {
        Task memory _task = tasks[_id];
        _task.done = !_task.done;
        tasks[_id] = _task;

        emit TaskToggleDone(_id, _task.done);
    }
}
