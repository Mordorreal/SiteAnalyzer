module OpenURI

  def OpenURI.redirectable?(uri1, uri2) # :nodoc:
    # This test is intended to forbid a redirection from http://... to
    # file:///etc/passwd, file:///dev/zero, etc.  CVE-2011-1521
    # https to http redirect is also forbidden intentionally.
    # It avoids sending secure cookie or referer by non-secure HTTP protocol.
    # (RFC 2109 4.3.1, RFC 2965 3.3, RFC 2616 15.1.3)
    # However this is ad hoc.  It should be extensible/configurable.
    uri1.scheme.downcase == uri2.scheme.downcase ||
        (/\A(?:http|ftp|https)\z/i =~ uri1.scheme && /\A(?:http|ftp|https)\z/i =~ uri2.scheme)
  end
end