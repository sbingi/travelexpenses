public abstract class AbstractTriggerHandler {
	
	private static Boolean alreadyRunning = false;
	
	
	// PUBLIC METHODS
	
	public void delegate() {
		if(!alreadyRunning) {
			alreadyRunning = true;
			
			if(Trigger.isBefore && Trigger.isInsert) {
				onBeforeInsert();
			}
			if(Trigger.isBefore && Trigger.isUpdate) {
				onBeforeUpdate();
			}
			if(Trigger.isBefore && Trigger.isDelete) {
				onBeforeDelete();
			}
			if(Trigger.isAfter && Trigger.isInsert) {
				onAfterInsert();
			}
			if(Trigger.isAfter && Trigger.isUpdate) {
				onAfterUpdate();
			}
			if(Trigger.isAfter && Trigger.isDelete) {
				onAfterDelete();
			}
			
			alreadyRunning = false;
		}
	}
	
	public virtual void onBeforeInsert() {}
	public virtual void onBeforeUpdate() {}
	public virtual void onBeforeDelete() {}
	
	public virtual void onAfterInsert() {}
	public virtual void onAfterUpdate() {}
	public virtual void onAfterDelete() {}
	
}