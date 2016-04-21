Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160122220435.GD5130@chrystal.uk.oracle.com>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
	<20151125234542.GA10324@chrystal>
	<CAGXu5jL8CzBum9Od1BhiwhVqOdJ0aZbCz126aCnu6zp1Zj6-0w@mail.gmail.com>
	<CAGXu5jLP4mfyeSoiMzTyGiRnx26Xp+US2djvY9MP0cDoBa2TBQ@mail.gmail.com>
	<20160122220435.GD5130@chrystal.uk.oracle.com>
Date: Thu, 21 Apr 2016 13:31:33 -0700
Message-ID: <CAGXu5j+ouWPyRStwzr2OKpcXaNXHFs3hKG9nyh5oxvJgF3EQqg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>, Michael Leibowitz <michael.leibowitz@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 22, 2016 at 2:04 PM, Quentin Casasnovas
<quentin.casasnovas@oracle.com> wrote:
> On Tue, Jan 19, 2016 at 04:03:12PM -0800, Kees Cook wrote:
>> On Fri, Nov 27, 2015 at 12:23 PM, Kees Cook <keescook@chromium.org> wrote:
>> > On Wed, Nov 25, 2015 at 3:45 PM, Quentin Casasnovas
>> > <quentin.casasnovas@oracle.com> wrote:
>> >> On Tue, Nov 24, 2015 at 11:10:09AM -0800, Kees Cook wrote:
>> >>> Hi,
>> >>>
>> >>
>> >> Hi Kees,
>> >>
>> >>> I just wanted to check in and see how progress was going on the stack
>> >>> overflow feature. Anything we can help with?
>> >>>
>> >>
>> >> Sorry for not following up on this, I've been busy and haven't had the time
>> >> to finish it properly.  I've pushed an initial WIP break up of the
>> >> KSTACK_OVERFLOW feature on my github:
>> >>
>> >>   https://github.com/casasnovas/linux/tree/quentin-split-kstackoverflow
>> >
>> > Great! Thanks for the update!
>>
>> Hi Quentin,
>>
>> Has anything moved on KSTACK_OVERFLOW? I'd love to start getting some
>> code tested if it's ready.
>>
>
> Hi Kees,
>
> Sorry I've been very bad at finding free time recenlty, being a new dad
> takes more time than expected :)

Congratulations! Yeah, seems to be a very time-consuming endeavor. But
you get a person out of it, so that's good. :)

> I've got next week off so hopefully I can spend some time on this, starting

I hope you used your week off for non-work things. :)

> with moving the thread_info off the stack and then splitting properly the
> rest of the KSTACK_OVERFLOW.

It seems like moving thread_info off the stack (and the gcc plugin
infrastructure) is a prerequisite for KRANDSTRUCT too, which Michael
has been looking at. If either of you have patches for this, I'd love
to get them on the list.

If you want to rebase off this, I've been tracking Emese's plugin work here:
http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kspp/gcc-plugins

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
