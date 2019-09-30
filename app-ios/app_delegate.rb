FirechatNS = 'https://firechat-ios.firebaseio-demo.com/'

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    ctlr = MyController.new
    first = UINavigationController.alloc.initWithRootViewController(ctlr)
    @window.rootViewController = first
    @window.makeKeyAndVisible

    true
  end
end


class MyController < UITableViewController

  attr_accessor :chat
  attr_accessor :firebase

  attr_accessor :textField

  def viewDidLoad
    super

    # Pick a random number between 1-1000 for our username.
    self.title = "Guest0x#{(rand * 1000).round.to_s(16).upcase}"

    # Initialize array that will store chat messages.
    self.chat = []

    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 44.0
    self.tableView.dataSource = tableView.delegate = self

    self.textField = UITextField.alloc.initWithFrame([[10, 0], [CGRectGetWidth(self.tableView.bounds) - 2*10, 44]])
    self.textField.placeholder = 'Type a new item, then press enter'
    self.textField.delegate = self
    self.tableView.tableHeaderView = self.textField

    setupFirebase
  end

  def setupFirebase
    # Initialize the root of our Firebase namespace.
    # Firebase.url = FirechatNS
    # self.firebase = Firebase.new
    
    # puts self.firebase.methods

    # self.firebase.on(:added) do |snapshot|
    #   # Add the chat message to the array.
    #   self.chat << snapshot.value.merge({'key' => snapshot.key})
    #   # Reload the table view so the new message will show up.
    #   self.tableView.reloadData
    # end

    # self.firebase.on(:changed) do |snapshot|
    #   index = self.chat.index {|chat| chat['key'] == snapshot.key}
    #   self.chat[index] = snapshot.value.merge({'key' => snapshot.key}) if index
    #   self.tableView.reloadData
    # end

    # self.firebase.on(:removed) do |snapshot|
    #   self.chat.delete_if {|chat| chat['key'] == snapshot.key}
    #   self.tableView.reloadData
    # end
  end


  # This method is called when the user enters text in the text field.
  # We add the chat message to our Firebase.
  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder

    # This will also add the message to our local array self.chat because
    # the FEventTypeChildAdded event will be immediately fired.
    self.firebase << {'name' => self.title, 'text' => text_field.text}

    text_field.text = ''
    false
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    self.chat.length
  end

  CellIdentifier = 'Cell'
  def tableView(tableView, cellForRowAtIndexPath:index_path)
    cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)

    unless cell
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellIdentifier)
    end

    chatMessage = self.chat[index_path.row]

    cell.textLabel.text = chatMessage['text']
    cell.detailTextLabel.text = chatMessage['name']

    return cell
  end

  def tableView(tableView, editActionsForRowAtIndexPath:indexPath)
    deleteAction = UITableViewRowAction.rowActionWithStyle(UITableViewRowActionStyleDestructive, title:'Delete', handler:lambda { |action, indexPath|
      tableView.editing = false

      chat = self.chat[indexPath.row]
      self.firebase[chat['key']].clear!
      self.chat.delete_at(indexPath.row)

      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
    })

    [deleteAction]
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    # required by tableView:editActionsForRowAtIndexPath:
  end
end



