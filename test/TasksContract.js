const TasksContract = artifacts.require("TasksContract")

contract("TasksContract", () => {

    before(async () => {
        this.tasksContract = await TasksContract.deployed()
    })

    it('migrate deployed successfully', async () => {
        const address = this.tasksContract.address

        assert.notEqual(address, null);
        assert.notEqual(address, undefined);
        assert.notEqual(address, 0x0);
        assert.notEqual(address, "");

    })

    it('task created successfully', async () => {
        const result = await this.tasksContract.createTask("some test task", "some description")
        const Tasks = await this.tasksContract.getMyTasks()
        const taskId = result.logs[0].args.taskId.toNumber();

        assert.equal(taskId, 0);
        assert.equal(Tasks[taskId].title, "some test task");
        assert.equal(Tasks[taskId].description, "some description");
        assert.equal(Tasks[taskId].done, false);
    })

    it('get all Tasks list', async () => {
        const Tasks = this.tasksContract.getMyTasks()

        assert.notEqual(Tasks, [])
        assert.notEqual(Tasks, null);
        assert.notEqual(Tasks, undefined);
    })

    it('task toggle done', async () => {
        const result = await this.tasksContract.toggleDone(0);
        const Tasks = await this.tasksContract.getMyTasks();
        const taskId = result.logs[0].args.id.toNumber();

        assert.equal(Tasks[taskId].done, true);
        assert.equal(Tasks[taskId].id, 0);
    })

    it('delete task successfully', async () => {
        const result = await this.tasksContract.deleteTask(0, true);
        const TaskEvent = result.logs[0].args;

        assert.equal(TaskEvent.taskId, 0)
        assert.equal(TaskEvent.isDeleted, true)
    })
})