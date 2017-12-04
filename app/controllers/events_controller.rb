class EventsController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @chapter = Chapter.find(params[:chapter_id])
    @events = @chapter.events

    breadcrumbs [@chapter.name, @chapter], "Events"
  end

  def show
    breadcrumbs event_breadcrumbs, @event.name
  end

  def new
    @event = Event.new(chapter_id: params[:chapter_id])

    breadcrumbs event_breadcrumbs, "New Event"
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event
    else
      render :new
    end
  end

  def edit
    @event.set_accessors
    @event = Event.find(params[:id])

    breadcrumbs event_breadcrumbs, @event.name
  end

  def update
    if @event.update(event_params)
      redirect_to @event
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
    authorize @event
  end

  def event_params
    params.require(:event).permit(:name, :occurs_at_date_str, :occurs_at_time_str, :description, :location, :chapter_id)
  end

  def event_breadcrumbs(include_link: true)
    ["Events", include_link ? chapter_events_path(@event.chapter) : nil]
  end
end