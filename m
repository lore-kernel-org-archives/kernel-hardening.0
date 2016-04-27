Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Apr 2016 10:30:59 +0200
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20160427083059.GB9223@chrystal.uk.oracle.com>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
 <20151125234542.GA10324@chrystal>
 <CAGXu5jL8CzBum9Od1BhiwhVqOdJ0aZbCz126aCnu6zp1Zj6-0w@mail.gmail.com>
 <CAGXu5jLP4mfyeSoiMzTyGiRnx26Xp+US2djvY9MP0cDoBa2TBQ@mail.gmail.com>
 <20160122220435.GD5130@chrystal.uk.oracle.com>
 <CAGXu5j+ouWPyRStwzr2OKpcXaNXHFs3hKG9nyh5oxvJgF3EQqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+ouWPyRStwzr2OKpcXaNXHFs3hKG9nyh5oxvJgF3EQqg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: kernel-hardening@lists.openwall.com
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

Wow, time just flew by.. !!  How are things?

On Thu, Apr 21, 2016 at 01:31:33PM -0700, Kees Cook wrote:
> On Fri, Jan 22, 2016 at 2:04 PM, Quentin Casasnovas
> >
> > Sorry I've been very bad at finding free time recenlty, being a new dad
> > takes more time than expected :)
> 
> Congratulations! Yeah, seems to be a very time-consuming endeavor. But
> you get a person out of it, so that's good. :)
>

Thanks! Oh yes. Right, it's the greatest feeling :)

> > I've got next week off so hopefully I can spend some time on this, starting
> 
> I hope you used your week off for non-work things. :)
>

I did, whoops.

> > with moving the thread_info off the stack and then splitting properly the
> > rest of the KSTACK_OVERFLOW.
> 
> It seems like moving thread_info off the stack (and the gcc plugin
> infrastructure) is a prerequisite for KRANDSTRUCT too, which Michael
> has been looking at. If either of you have patches for this, I'd love
> to get them on the list.

Gah I'm really sorry, I have no progress to communicate so far.  I didn't
really find the time in the past few months but I do intend to work on this
if nobody beats me to it!

To bo honest I was a bit put off by Brad's comments on his twitter account,
making fun of the few things I initially missed.  I realise now, given his
own reaction to mistakes, that I should not have.

> 
> If you want to rebase off this, I've been tracking Emese's plugin work here:
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kspp/gcc-plugins
>

Great thanks!  Pretty cool Dmitry's gcc patch was ported to its own plugin,
as I've mentioned in the past we've been using that here to run AFL on the
kernel, so it's great if it makes it to mainline!

Quentin
