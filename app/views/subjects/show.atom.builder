atom_feed :language => 'ja-JP' do |feed|
  feed.title @subject.name
  feed.updated @updated

  @activities.each do |item|
    next if item.updated_at.blank?

    feed.entry( item ) do |entry|
      entry.url subject_path(@subject)
      entry.title activity_label(item)
      entry.content item.content, :type => 'html'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name item.user.name
      end
    end
  end
end
