IVA = 0.18

DEFAULT_GRAVATAR_OPTIONS = {
  # The URL of a default image to display if the given email address does
  # not have a gravatar.
  :default => nil,

  # The default size in pixels for the gravatar image (they're square).
  :size => 50,

  # The maximum allowed MPAA rating for gravatars. This allows you to
  # exclude gravatars that may be out of character for your site.
  :rating => 'PG',

  # The alt text to use in the img tag for the gravatar.  Since it's a
  # decorational picture, the alt text should be empty according to the
  # XHTML specs.
  :alt => '',

  # The class to assign to the img tag for the gravatar.
  :class => 'gravatar',

  # Whether or not to display the gravatars using HTTPS instead of HTTP
  :ssl => false,
}
