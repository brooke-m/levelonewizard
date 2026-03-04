# level one wizard

This is a prototype multi-step onboarding wizard in rails 8.

It allows the user to step back and forward between different steps in signup,
validates that each step has recieved its appropriate field and displays a
summary of the collected information at the end.

The idea here was that `Signup` is an record that gets added to with each step
and tracks its own progress, and then a completed signup would be translated
into a `User` (which isn't in scope but you can check the schema for reference re: the shape of a User) model which would theoretically be used in the actual application.

A Signup is created with (and indexed on) the supplied email, and the other
fields either have defaults or can be temporarily nil. Styled with tailwind,
step navigation done as a series of edits/patches with conditional rendering:
the edit view displays different fields depending on the current signup step.

Some tests can be found in `test/models` and `test/controllers`.

## installation.

1. Clone the repo
2. Run `bundle install`
3. Run `rails db:migrate`
4. Run `bin/dev`
5. Click 'new signup' to start the flow.

## potential extensions.

There are a number of ways that the prototype can be improved, with varying
levels of required effort. A full-on production build for something that
works at scale would probably take a different approach, but with respect to
the prototype:

- **progress indicator:** The information needed to render this is all there,
  mainly the `current_step` int on the Signup model. This was close to making
  it in the time limit.
- **hotwire and co:** It would be nicer with frame/stream as the conditional
  underlying the 2 hour wizard is not exactly nice for scaling up and out.
- **admin-facing view:** Again, all the info is there! Currently for local testing
  the app lands on the index view which captures some (but not all) of the info
  per-signup. The majority of the work involved in building that out for real would
  be determining an approach to auth and how to determine/represent what an Admin is.
  - To support this, model scopes like `complete` or `inactive` (incomplete
    and long enough since last update that it could be considered stale) could support
    admin actions on the signups.
- **resume support:** Part of the reason it's indexed on a unique email is that
  my idea for a first cut at resume supporting would be (because I focused on
  saving to db and not so much on the session) to start on the first step and
  then if that email matches an existing but not finished signup it could
  re-route to the latest step of a partial signup.
- **steps as enum:** Bit of a nitpick but the early version of tracking steps is
  just updating an integer, and something like `enum step: { email: 0, name: 1, ..}` would be nicer and definitely a better fit for a full build.
- **adding more than one field per step:** It'd be straightforward to group fields and
  extend the basic validation to handle this. What would be even nicer is more
  robust validation.
- **visual/ux updates:** It would be good to make it look and feel nicer, though
  this comes under 'hotwire and co' a bit. UX testing etc could follow and better
  inform the final flow.
- **accessibility:** Ideally I'd go back through and get it up to accessible
  standards or at least consistently use aria labels.

## known issues.

1. The form will not go back through the steps if the required field is left blank.
   _(This is the big one, really. The downside of going the 'update' route, but in hindsight maybe it could be worked around by making the form fields themselves
   optional and bringing the validation through to the view?)_
2. The form will not proceed without the user checking the box to recieve emails.
3. The ability to 'go back' into the edit forms from the summary is broken.
4. Some visual elements are misaligned. Form fields that are required are missing
   a signifier that demonstrates that before submission.
