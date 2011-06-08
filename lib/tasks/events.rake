def parse_stack(et)
  stack = Event.unpublished.where(:subject_id => et.subject_id, :subject_type => et.subject_type).order('created_at DESC').all

  parse_events(stack) unless stack.empty?
  et.destroy
end


def parse_events(stack)
  if stack.length == 1
    ev = stack.first
    ev.update_attribute :published, true
    return
  end

  ev = stack.first
  stack.delete(ev)
  if ev.event_type.starts_with?("destroyed_")
    #Esborrem els altres events i deixem nomes el destroyed
    stack.each do |x|
      x.destroy
    end
    ev.update_attribute :published, true

  elsif ev.event_type.starts_with?("modified_")
    if stack.first.event_type.starts_with?("modified_")
      #Deixem nomes el event de modificacio mes nou
      r = stack.first
      stack.delete(r)
      r.destroy
      stack.insert(0, ev)
    else
      #Deixem nomes la noticia de creacio, que es mes important
      ev.destroy
    end
    parse_events(stack)
  end
end

