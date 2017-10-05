MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC563F4AD0AF@ORSMSX115.amr.corp.intel.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
 <20171005021915.GK16685@eros> <CA+55aFwac2BzgZs-X1_VhekkuGfuLqNui2+2DbvLiDyptS-rXQ@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AD0AF@ORSMSX115.amr.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Oct 2017 09:19:17 -0700
Message-ID: <CA+55aFxjsKRhuzpQjRff6b6emJBFHtefUwnDfv+zgrxmUDvqkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 5, 2017 at 8:12 AM, Roberts, William C
<william.c.roberts@intel.com> wrote:
>
> I think one of the reasons it didn't work was that it was opt-in via %pK.

I agree that the opt-in doesn't work, but I really don't think a
config option really works either, and in the case of '%p',
unconditionally doing it everywhere wasn't really an option.

The "check if root' only works in synchronous contexts (and not well
there either, since it's often not about the current task, but about
the current file descriptor etc).

The "always print 0" model obviously does work, but then you really
have to have a strategy for moving away from %p users entirely.

And I'm willing to do that, but then I think we'd need to

 (a) get rid of kptr_restrict entirely, because as long as it exists
the "fix" for any problem is always going to be "just boot with this
disabled".

     And no, that "just boot with it disabled" is not an acceptable
model. It's what we've been doing exactly because it's not acceptable.

     We already don't get great bug reports. If we now start getting
bug reports and tell users "recreate this with 'kptr_enabled' on the
kernel command line" because some debug message didn't give proper
data, that will just result in us getting even less bug reports.

 (b) have some plan in place for people who end up just using %x instead.

Part of "b" might be to not print out zeroes, but something more useful.

Because *most* %p users are for debugging, I think. There tends to be
at least a couple of places:

 - debug messages that want to indicate which object we're talking
about. The actual pointer is not important, but the pointer to the
device descriptor or whatever is used as a "unique ID" for the case
where there might be multiple.

 - meaningful hardware addresses (ie the pointer is some mmio pointer).

At least the first case could possibly continue to use a '%p' that
simply hashes the actual pointer value with some hash or something
like that. It's not the pointer itself that is important, it's just
the "identity" of the socket or device or whatever.

Of course, "just hash it" isn't good enough if we're just hiding the
(very limited) kernel address space randomization, but mixing in a
per-boot random value might be sufficient.

So if instead of just printing zeroes, we'd still print something that
is a useful _identity_, maybe a lot of existing users of '%p' would
still be ok with it.

Which would limit that (b) issue.

What do people think? Literally something like

  diff --git a/lib/vsprintf.c b/lib/vsprintf.c
  index 86c3385b9eb3..a995227a1918 100644
  --- a/lib/vsprintf.c
  +++ b/lib/vsprintf.c
  @@ -1708,7 +1708,8 @@ static noinline_for_stack
   char *pointer(const char *fmt, char *buf, char *end, void *ptr,
                 struct printf_spec spec)
   {
  -        const int default_width = 2 * sizeof(void *);
  +        const int default_width = 8;
  +        unsigned int hashval;

           if (!ptr && *fmt != 'K') {
                   /*
  @@ -1865,7 +1866,12 @@ char *pointer(const char *fmt, char *buf,
char *end, void *ptr,
           }
           spec.base = 16;

  -        return number(buf, end, (unsigned long) ptr, spec);
  +        hashval = hash_three_words(
  +                (unsigned long)ptr,
  +                (unsigned long)ptr >> 16 >> 16,
  +                boot_time_random_int);
  +
  +        return number(buf, end, hashval, spec);
   }

   /*

which just means that a pointer that falls through to the hex version
will always just be shown as a 32-bit hash. It will hash to the same
thing for any particular boot, so you'll recognize values you already
know, but it should be pretty hard to use it for an attack that needs
to figure out the pointer.

Yes, if you want the "real" pointer, you'd need to switch to '%x', but
that is at least _potentially_ a much smaller set of cases now.

Hmm?

I have *not* tried the above out in practice. But something like that
seems at least potentially realistic to me as a way forward.

Comments?

                     Linus
