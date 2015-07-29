#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class JournalNotificationMailer
  class << self
    def distinguish_journals(journal, send_notification)
      if send_notification
        if journal.journable_type == 'WorkPackage'
          handle_work_package_journal(journal)
        end
      end
    end

    def handle_work_package_journal(journal)
      return nil unless send_notification? journal

      job = DeliverWorkPackageNotificationJob.new(journal.id, User.current.id)

      Delayed::Job.enqueue job, run_at: delivery_time
    end

    def send_notification?(journal)
      (Setting.notified_events.include?('work_package_added') && journal.initial?) ||
        Setting.notified_events.include?('work_package_updated') ||
        notify_for_notes?(journal) ||
        notify_for_status?(journal) ||
        notify_for_priority(journal)
    end

    def notify_for_notes?(journal)
      Setting.notified_events.include?('work_package_note_added') && journal.notes.present?
    end

    def notify_for_status?(journal)
      Setting.notified_events.include?('status_updated') &&
        journal.changed_data.has_key?(:status_id)
    end

    def notify_for_priority(journal)
      Setting.notified_events.include?('work_package_priority_updated') &&
        journal.changed_data.has_key?(:priority_id)
    end

    def delivery_time
      Setting.journal_aggregation_time_minutes.to_i.minutes.from_now
    end
  end
end
