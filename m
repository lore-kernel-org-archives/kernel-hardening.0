References: <20170505232018.28846-1-matt@nmatt.com>
 <20170510212920.7f6bc5e6@alans-desktop>
 <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
 <20170515215752.4e9f3826@alans-desktop>
 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com>
Date: Tue, 16 May 2017 00:15:00 -0400
MIME-Version: 1.0
In-Reply-To: <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Peter Dolding <oiaohm@gmail.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 05/15/2017 07:10 PM, Peter Dolding wrote:
> On Tue, May 16, 2017 at 6:57 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>> O> I'm not implying that my patch is supposed to provide safety for
>>> "hundreds of other" issues. I'm looking to provide a way to lock down a
>>> single TTY ioctl that has caused real security issues to arise. For
>>
>> In other words you are not actually fixing anything.
>>
>>> this reason, it's completely incorrect to say that this feature is
>>> snake oil. My patch does exactly what it claims to do. No more no less.
>>>
>>>> In addition your change to allow it to be used by root in the guest
>>>> completely invalidates any protection you have because I can push
>>>>
>>>> "rm -rf /\n"
>>>>
>>>> as root in my namespace and exit
>>>>
>>>> The tty buffers are not flushed across the context change so the shell
>>>> you return to gets the input and oh dear....
>>>
>>> This is precisely what my patch prevents! With my protection enabled, a
>>> container will only be able to use the TIOCSTI ioctl on a tty if that
>>> container has CAP_SYS_ADMIN in the user namespace in which the tty was
>>> created.
>>
>> Which is not necessarily the namespace of the process that next issues a
>> read().
>>
>> This is snake oil. There is a correct and proper process for this use
>> case. That proper process is to create a new pty/tty pair. There are two
>> cases
>>
>> - processes that do it right in which case the attacker is screwed and we
>>   don't need to mess up TIOCSTI handling for no reason.
>>
>> - processes that do it wrong. If they do it wrong then they'll also use
>>   all the other holes and attacks available via the same path which are
>>   completely unfixable without making your system basically unusable.
>>
>>
>> So can we please apply the minimum of common sense reasoning to this and
>> drop the patch.
>>
>> Alan
> You missed some important.
>
> From: http://man7.org/linux/man-pages/man7/capabilities.7.html
> Don't choose CAP_SYS_ADMIN if you can possibly avoid it!
> A vast  proportion of existing capability checks are associated with this
> capability (see the partial list above).  It can plausibly be
> called "the new root", since on the one hand, it confers a wide
> range of powers, and on the other hand, its broad scope means that
>  this is the capability that is required by many privileged
> programs.  Don't make the problem worse.  The only new features
> that should be associated with CAP_SYS_ADMIN are ones that closely
> match existing uses in that silo.
>

That last sentence is the key. CAP_SYS_ADMIN is already associated with
the TIOCSTI ioctl!

 From the same capabilities man page you quote above
under the CAP_SYS_ADMIN section:
employ the TIOCSTI ioctl(2) to insert characters into the input queue
of a terminal other than the caller's controlling terminal;

> This not only a improper fix the attempted fix is breach do
> documentation.   CAP_SYS_ADMIN is that far overloaded it does not
> require any more thrown in it direction.
>

See my comment above. This is clearly following the capabilities
documentation since CAP_SYS_ADMIN is already closely linked with the
TIOCSTI ioctl.

> This is one of the grsecurity patches mistakes.   GRKERNSEC_HARDEN_TTY
>  is from 18 Feb 2016 this documentation as in place at the time they
> wrote this.  Yes GRKERNSEC_HARDEN_TTY does exactly the same thing.
> Yes Grsecurity guys did the same error and the grsecurity patches are
> filled with this error.
>
> The result is from the TIOCSTI patch done this way is you have to use
> CAP_SYS_ADMIN to use TIOSCTI so opening up every exploit that
> Grsecurity has added and every exploit CAP_SYS_ADMIN can do what is
> quite a few.
>
> Now I don't know if CAP_SYS_TTY_CONFIG what is an existing capability
> might be what TIOCSTI should own under.
>

I could see a case being make for CAP_SYS_TTY_CONFIG. However I still
choose to do with CAP_SYS_ADMIN because it is already in use in the
TIOCSTI ioctl.

> The reality here is CAP_SYS_ADMIN as become the Linux kernel security
> equal what big kernel lock was for multi threading.
>
>  In a ideal world CAP_SYS_ADMIN would not be used directly in most
> cases.  Instead CAP_SYS_ADMIN would have a stack of sub capabilities
> groups under it.
>
> The excuse for doing it wrong grsecurity is
> https://forums.grsecurity.net/viewtopic.php?f=7&t=2522
>
> Yes most capabilities open up possibility of exploiting the system.
> They are not in fact designed to prevent this.   They are designed to
> limit the damage in case of malfunction so that a program/user has
> only limited methods of damaging the system.  Like a program
> malfunctioning with only limit capabilities if it does an action those
> capabilities don't allow no damage will happen.   Now CAP_SYS_ADMIN is
> for sure not limited.
>
> But since grsecurity developers took the point of view these are False
> Boundaries they then proceed to stack item after item under
> CAP_SYS_ADMIN because the boundary made no sense to them.    Also some
> mainline Linux Kernel developers are guilty of the same sin of
> overloading CAP_SYS_ADMIN.
>
> From my point of view any new patching containing CAP_SYS_ADMIN
> directly used should be bounced just for that.   If features need to
> be added to CAP_SYS_ADMIN now they should have to go into another
> capability that is enabled when  CAP_SYS_ADMIN is and hopeful if we do
> this over time we will be able to clean up CAP_SYS_ADMIN into sanity.
>

You might be right that CAP_SYS_ADMIN is overloaded, but my patch
barely adds anything to it since TIOCSTI already falls under its
control. It seems extreme to say this patch ought to be rejected just
because it contains CAP_SYS_ADMIN. If we want to fix the state of Linux
capabilities, then I suggest that should be a separate patchset to
reorganize them into a more modular set of controls.

>
> Peter
>
