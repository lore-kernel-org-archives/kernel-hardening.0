Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Nov 2015 11:42:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20151106194202.GB9437@kroah.com>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
 <CAEXv5_g07h_LhAx0M_xS5Km7kzrFXf7R-tbdhzcYicZna+pjkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXv5_g07h_LhAx0M_xS5Km7kzrFXf7R-tbdhzcYicZna+pjkg@mail.gmail.com>
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 05, 2015 at 04:14:22PM -0500, David Windsor wrote:
> I also proposed a patch for adding overflow protection to kref [2], but that
> patch was ultimately shot down.  Point being, I have some related patches
> laying around that directly relate to refcount-based protection which might be
> useful here. 

It was "shot down" because you crashed the system with your patch, which
isn't ok, it is a recoverable issue, and no one resent it in a version
that didn't do this.

Also, I'm not quite sure of what exactly you are trying to protect here
with a kref overflow patch, the threat-model you are going after was
never documented.

thanks,

greg k-h
