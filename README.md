# level one wizard

This is a prototype multi-step onboarding wizard in rails 8.

It allows the user to step back and forward between different steps in signup,
validates that each step has recieved its appropriate field and displays a
summary of the collected information at the end.

The idea here was that `Signup` is an object that gets added to and then tracks
its progress, and a completed signup would be translated into a `User` (which
isn't in scope but you can check the schema for reference re: the shape of a
User).

A Signup is created with (and indexed by) the supplied email, and the other
fields either have defaults or can be temporarily nil. Styled with tailwind,
step navigation done as a series of edits/patches with conditional rendering:
the edit view displays different fields depending on the current signup step.

## installation.

1. Clone the repo
2. Run `bundle install`
3. Run `rails db:migrate`
4. Run `bin/dev`
5. Click 'new signup' to start the flow.

## potential extensions.

- **progress indicator:** The information needed to render this is all there,
  mainly the `current_step` int on the Signup model.
- **hotwire and co:** It would be nicer with frame/stream as the conditional
  underlying the 2 hour wizard is not exactly nice for scaling up and out.
- **admin-facing view:** Again, all the info is there! Currently for local testing
  the app lands on the index view which captures some (but not all) of the info
  per-signup. The majority of the work involved in building that out for real would
  be determining an approach to auth and how to determine/represent what an Admin is.
  - To support this, model scopes like `complete` or even `inactive` (incomplete
    and long enough since last update that it could be considered stale) could support
    admin actions on the signups.
- **resume support:** Part of the reason it's indexed on a unique email is that
  my idea for a first cut at resume supporting would be to always start on the first
  step and then if that email matches an existing but not finished signup it could
  re-route to the latest step of a partial signup.
- **steps as enum:** The early version of tracking steps is just updating an
  integer, but something like `enum step: { email: 0, name: 1, ..}` would be
  nicer and definitely a better fit for a full build.
- **adding more than one field per step:** It'd be easy to group fields and
  get the basic validation to handle this.

## known issues.

1. The form will not proceed without the user checking the box to recieve emails.
2. The ability to 'go back' into the edit forms from the summary is broken.
3. Some visual elements are misaligned.
