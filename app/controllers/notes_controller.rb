# encoding: UTF-8

class NotesController < ApplicationController
  def new
    @subject = Subject.find(params[:subject_id])
    recent_note = Note.recent(@subject) || Note.new(content: '')
    @note = @subject.notes.build(content: recent_note.content)
  end

  def create
    @subject = Subject.find(params[:subject_id])
    @note = @subject.notes.build(params[:note])
    @note.user = current_user

    if @note.save
      redirect_to subject_path(@subject)
    else
      redirect_to subject_path(@subject)
    end
  end

  def index
    @subject = Subject.find(params[:subject_id])
    @notes = @subject.notes
  end

  def show
    @note = Note.find(params[:id])
    @subject = @note.subject
  end
end
