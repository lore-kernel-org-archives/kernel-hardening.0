MIME-Version: 1.0
In-Reply-To: <CAGXu5jL1rSp1xVEa4aD=vzOb9Me5BEUoxO=c5f40jSYuxDSUPw@mail.gmail.com>
References: <CABeRdtq0BY8Hi=9hHCx7YAfc=wTfVds3feN3p0BdLySjnwc1ng@mail.gmail.com>
 <CAGXu5jJf_Vi=O7SLpiMRjdjgAzhkPF+bfjddoBsgSkLz+yw+Yg@mail.gmail.com>
 <CABeRdtobtD7C3AeY01RTe6ChJnOMYLyWRrubWD0mwGQYANzfpQ@mail.gmail.com> <CAGXu5jL1rSp1xVEa4aD=vzOb9Me5BEUoxO=c5f40jSYuxDSUPw@mail.gmail.com>
From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sat, 28 Jan 2017 04:03:01 +0900
Message-ID: <CABeRdto9-vPTXT59waFZDHUfeCjhjqecdVhL04zbm6kD4LP=0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] I'd like to contribute to this project.
To: Kees Cook <keescook@chromium.org>
Cc: Richard Weinberger <richard@nod.at>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 27, 2017 at 6:36 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jan 26, 2017 at 6:49 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> > On Thu, Jan 26, 2017 at 4:41 AM, Kees Cook <keescook@chromium.org> wrote:
> >> On Wed, Jan 25, 2017 at 6:01 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> >>> Hi. I'm Hoeun Ryu.
> >>
> >> Hi! Nice to meet you!
> >>
> >>> I've been reading arm/arm64 and mm/fs kernel code for the last few years.
> >>> I stumbled upon the wiki page for this project and found this project seems
> >>> very interesting.
> >>> I think I can start to contibute to this project from porting small parts of
> >>> PAX/GRSEC features that you guys haven't worked on yet.
> >>
> >> Sure, that would be very welcome. Are there features you're especially
> >> interested in?
> >>
> >
> > I tried to find out what features PAX/GRKERNSEC provides reading
> > grsecurity wiki pages and the patch file today.
> > It might take a week or two to find adequate features for me to tackle.
> > But my guess after few hours of a brief investigation is `Deter
> > exploit bruteforcing (GRKERNSEC_BRUTE)`
> > Do you think the feature is worth it to you guys ? If not, please
> > recommend others.
>
> I'd really like to see this, yes. There have been attempts in the past
> that got derailed. I strongly think it should be part of the kernel
> (and not glibc, as got proposed):
>
> https://lkml.org/lkml/2014/12/24/306
>
> I think it's worth trying it again.

Ok. I will start to investigate the history of Richard's try for the
feature and GRKERNSEC_BRUTE itself and how I can narrow the gap
between the opinions.

>
> >>> I'd like to start from something trivial so I can do it in my free time.
> >>> It's also ok to work with someone who are working on a big patch series if
> >>> you need help.
> >>
> >> Just looking through the list of things on the wiki, how about this?
> >> - add zeroing of copy_from_user on failure test to test_usercopy.c
> >>
> >> The issue here is that when a copy_from_user() call fails (for
> >> whatever reason), the kernel is supposed to clear the destination
> >> buffer with zeros to make sure nothing is accidentally exposed later
> >> (if, say, it is copied back to userspace at a later time). We saw a
> >> few instances where this protective copying wasn't happening, but
>
> >> there was no regression test for it.
> >>

What are the few instances? Invaild sized accesses ?
You mean that the regression is performance degradation ?

> >> Adding a test to lib/test_usercopy.c for the zeroing would be nice to
> >> have, and should be a relatively small change.
> >>

What can be the test cases ?
Performing copy_to/from_user against different kind of src/dst like
stack, slab and simple kmalloc()ed pages and checking
if the results are what they should be ?
Or just checking if zeroing is done by comparing the content of memory to 0 ?

>
> >> Let me know if that sounds good to you, and thanks!
> >>
> >
> > It sounds good, of course. I can work on it.
> > Your help during my struggle for it will be appreciated.
>
> Cool, let us know how we can help. :)
>
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
