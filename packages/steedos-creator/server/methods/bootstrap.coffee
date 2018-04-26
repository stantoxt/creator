Meteor.methods

	"creator.bootstrap": (space_id)->
		if !this.userId
			return null

		# check if user in the space
		su = Creator.Collections["space_users"].findOne({space: space_id, user: this.userId})
		if !su
			space_id == null

		# if space_id not exists, get the first one.
		if !space_id
			su = Creator.Collections["space_users"].findOne({user: this.userId})
			if !su
				return null
			space_id = su.space

		space = Creator.Collections["spaces"].findOne({_id: space_id}, {fields: {name: 1}})

		result = Creator.getAllPermissions(space_id, this.userId)
		result.space = space
		result.apps = _.extend Creator.getDBApps(space_id), Creator.Apps
		result.object_listviews = Creator.getUserObjectsListViews(this.userId, space_id, result.objects)
		result.object_workflows = Meteor.call 'object_workflows.get', space_id

		return result;

