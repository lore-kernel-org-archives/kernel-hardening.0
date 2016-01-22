Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 22 Jan 2016 23:04:35 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20160122220435.GD5130@chrystal.uk.oracle.com>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
 <20151125234542.GA10324@chrystal>
 <CAGXu5jL8CzBum9Od1BhiwhVqOdJ0aZbCz126aCnu6zp1Zj6-0w@mail.gmail.com>
 <CAGXu5jLP4mfyeSoiMzTyGiRnx26Xp+US2djvY9MP0cDoBa2TBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLP4mfyeSoiMzTyGiRnx26Xp+US2djvY9MP0cDoBa2TBQ@mail.gmail.com>
Subject: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: Kees Cook <keescook@chromium.org>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 04:03:12PM -0800, Kees Cook wrote:
> On Fri, Nov 27, 2015 at 12:23 PM, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Nov 25, 2015 at 3:45 PM, Quentin Casasnovas
> > <quentin.casasnovas@oracle.com> wrote:
> >> On Tue, Nov 24, 2015 at 11:10:09AM -0800, Kees Cook wrote:
> >>> Hi,
> >>>
> >>
> >> Hi Kees,
> >>
> >>> I just wanted to check in and see how progress was going on the stack
> >>> overflow feature. Anything we can help with?
> >>>
> >>
> >> Sorry for not following up on this, I've been busy and haven't had the time
> >> to finish it properly.  I've pushed an initial WIP break up of the
> >> KSTACK_OVERFLOW feature on my github:
> >>
> >>   https://github.com/casasnovas/linux/tree/quentin-split-kstackoverflow
> >
> > Great! Thanks for the update!
> 
> Hi Quentin,
> 
> Has anything moved on KSTACK_OVERFLOW? I'd love to start getting some
> code tested if it's ready.
> 

Hi Kees,

Sorry I've been very bad at finding free time recenlty, being a new dad
takes more time than expected :)

I've got next week off so hopefully I can spend some time on this, starting
with moving the thread_info off the stack and then splitting properly the
rest of the KSTACK_OVERFLOW.

Quentin
