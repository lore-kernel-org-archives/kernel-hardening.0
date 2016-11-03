Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 3 Nov 2016 05:03:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20161103050302.GC19539@ZenIV.linux.org.uk>
References: <1478106169-25770-1-git-send-email-vaishali.thakkar@oracle.com>
 <20161102204453.GA18842@remoulade>
 <CAGXu5j+go+Fr2OeF-R4BtVHRcBRrC0TaU477J4RwEAe4zDRZ9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+go+Fr2OeF-R4BtVHRcBRrC0TaU477J4RwEAe4zDRZ9A@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [kernel-hardening] [RFC PATCH] lib: Harden
 csum_partial_copy_from_user
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Vaishali Thakkar <vaishali.thakkar@oracle.com>, Mark Rutland <mark.rutland@arm.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 02, 2016 at 03:59:25PM -0600, Kees Cook wrote:
> On Wed, Nov 2, 2016 at 2:44 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > Hi,
> >
> > On Wed, Nov 02, 2016 at 10:32:49PM +0530, Vaishali Thakkar wrote:
> >> The routine csum_partial_copy_from_user is same as csum_partial_copy
> >> but it copies from user space for the checksumming. In other respects
> >> it is identical, and can be used to copy an arbitrarily large buffer
> >> from userspace into the kernel. Conceptually this exposes a similar
> >> attack surface like copy_from_user. So, to validate the given address
> >> we should call check_object_size here.
> >
> > Thanks for looking at this! I agree that we should be trying lock down these
> > homebrew/specialised copy_{to,from}_user routines.
> 
> Yes, I'm glad to have more eyes on this. I did notice that these are
> almost exclusively used in networking. I'd be curious to see how
> noticeable this is on performance (though see my inlining comment
> below...)

No check_object_size() in that place.  Really.  Look through the call chains.

> Al, is your pass at improving uaccess currently finished, or do you
> have more changes coming?

Yes, and quite a few.  There's going to be a lot of merging between the
architectures in that area.

As for csum stuff...  csum_partial_copy_from_user() is *NOT* an exposed
API.  Really.  It's a helper often used by implementations of
csum_partial_copy_nocheck() and csum_and_copy_from_user().  Those two
are parts of API.  With very limited use.  csum_and_copy_from_user()
has literally only one user - csum_and_copy_from_iter().

csum_partial_copy_nocheck() has slightly wider use.  It has nothing to do
with userland memory, though, and should never be used for such.  First of all,
it's used in implementation of csum_and_copy_{to,from}_iter().  Then
there are
	* skb_copy_and_csum_bits()
	* getfrag callbacks of ip_append_data() - icmp_push_reply(),
ip_reply_glue_bits(), raw_getfrag(), raw6_getfrag()
	* tcp_fragment()
	* really weird shit in drivers/net/ethernet/3com/typhoon.c - the
hardware apparently uses IP-style csum as a signature for the firmware.
Yes, really.  Comments regarding the value of such 'protection' (whatever
it was they were trying to protect) are best directed to 3COM people.

	What would you check the sizes of?  The most common users are
csum_and_copy_from_iter() and skb_copy_and_csum_bits().  And serious
overhead added to either of those will be _very_ painful.
