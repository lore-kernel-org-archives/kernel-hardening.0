Date: Thu, 26 Oct 2017 09:14:11 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171025221411.GA12341@eros>
References: <1508798008-1692-1-git-send-email-me@tobin.cc>
 <87bmkw5owv.fsf@rasmusvillemoes.dk>
 <20171024235755.GA15832@eros>
 <CAKwiHFgUEfXJ3TRzwD4dm6TFVM6ffdzb-riMAhnobnZrjD0ySw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwiHFgUEfXJ3TRzwD4dm6TFVM6ffdzb-riMAhnobnZrjD0ySw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 25, 2017 at 09:02:34PM +0200, Rasmus Villemoes wrote:
> On 25 October 2017 at 01:57, Tobin C. Harding <me@tobin.cc> wrote:
> > On Tue, Oct 24, 2017 at 09:25:20PM +0200, Rasmus Villemoes wrote:
> >>
> >> I haven't followed the discussion too closely, but has it been
> >> considered to exempt NULL from hashing?
> >
> [snip]
> >
> > The code in question is;
> >
> > static noinline_for_stack
> > char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> >               struct printf_spec spec)
> > {
> >         const int default_width = 2 * sizeof(void *);
> >
> >         if (!ptr && *fmt != 'K') {
> >                 /*
> >                  * Print (null) with the same width as a pointer so it makes
> >                  * tabular output look nice.
> >                  */
> >                 if (spec.field_width == -1)
> >                         spec.field_width = default_width;
> >                 return string(buf, end, "(null)", spec);
> >         }
> 
> Ah, yes, I should have re-read the current code before commenting. So
> we're effectively already exempting NULL due to this early handling.
> Good, let's leave that.
> 
> Regarding the tabular output: Ignore it, it's completely irrelevant to
> the hardening efforts (good work, btw), and probably completely
> irrelevant period. If anything I'd say the comment and the attempted
> alignment should just be killed.

Righto, I'm happy with that. Will add to next version.

> > This check and print "(null)" is at the wrong level of abstraction. If we want tabular output to be
> > correct for _all_ pointer specifiers then spec.field_width (for NULL) should be set to match whatever
> > field_width is used in the associated output function. Removing the NULL check above would require
> > NULL checks adding to at least;
> >
> > resource_string()
> > bitmap_list_string()
> > bitmap_string()
> > mac_address_string()
> > ip4_addr_string()
> > ip4_addr_string_sa()
> > ip6_addr_string_sa()
> > uuid_string()
> > netdev_bits()
> > address_val()
> > dentry_name()
> > bdev_name()
> > ptr_to_id()
> 
> No, please don't. The NULL check makes perfect sense early in
> pointer(), because many of these handlers would dereference the
> pointer, and while it's probably a bug to pass NULL to say %pD, it's
> obviously better to print (null) than crash. Adding NULL checks to
> each of these is error-prone and lots of bloat for no real value
> (consider that many of these can produce lots of variants of output,
> and e.g. dotted-decimal ip addresses don't even have a well-defined
> width at all).
> 
> > My question is [snip] is it too trivial to matter?
> 
> Yes.

thanks,
Tobin.
