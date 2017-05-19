MIME-Version: 1.0
In-Reply-To: <CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com>
References: <20170505232018.28846-1-matt@nmatt.com> <20170510212920.7f6bc5e6@alans-desktop>
 <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com> <20170515215752.4e9f3826@alans-desktop>
 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com> <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com> <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
 <20170517174113.69d1cbaa@alans-desktop> <1495045540.1619.1.camel@gmail.com> <CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com>
From: Peter Dolding <oiaohm@gmail.com>
Date: Fri, 19 May 2017 12:48:17 +1000
Message-ID: <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matt Brown <matt@nmatt.com>, "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 18, 2017 at 1:18 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, May 17, 2017 at 11:25 AM, Daniel Micay <danielmicay@gmail.com> wrote:
>> On Wed, 2017-05-17 at 17:41 +0100, Alan Cox wrote:
>>> > If we're adjusting applications, they should be made to avoid
>>> > TIOSCTI
>>> > completely. This looks to me a lot like the symlink restrictions:
>>> > yes,
>>> > userspace should be fixed to the do the right thing, but why not
>>> > provide support to userspace to avoid the problem entirely?
>>>
>>> We do it's called pty/tty. There isn't any other way to do this
>>> correctly
>>> because TIOCSTI is just one hundreds of things the attacker can do to
>>> make your life miserable in the case you create a child process of
>>> lower
>>> security privilege and give it your tty file handle or worse (like
>>> some
>>> container crapware) your X11 socket fd.
>>>
>>> Does it really matter any more or less if I reprogram your enter key,
>>> use
>>> TIOCSTI, set the baud rate, change all your fonts ?
>>>
>>> The mainstream tools like sudo get this right (*). Blocking TIOCSTI
>>> fixes
>>> nothing and breaks apps. If it magically fixed the problem it might
>>> make
>>> sense but it doesn't. You actually have to get an adult to write the
>>> relevant code.
>>
>> It gets it right because it was reported as a vulnerability and fixed,
>> which is the cycle many of these tools have gone through. It looks like
>> sudo and coreutils / shadow su were fixed in 2005, but there are more of
>> these tools.
>>
>> CVE-2005-4890 (coreutils su, shadow su, sudo), CVE-2016-7545 (SELinux
>> sandbox utility), CVE-2016-2781 (chroot --userspec), CVE-2016-2779
>> (util-linux runuser), CVE-2016-2568 (pkexec)
>>
>> I am not sure if the pkexec vulnerability is even fixed:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=1300746
>>
>> CVE-2017-5226 is for bubblewrap/flatpak this year, and I'm sure there
>> were a lot more as I didn't bother to dig very deep.
>>
>> I completely agree that it should be solved by doing things properly in
>> each application. However, it isn't solved properly everywhere and each
>> new application is making the same mistake. Providing this feature does
>> not break anything that people use in practice and it doesn't need to
>> solve every issue to be quite useful, it only needs to prevent local
>> privilege escalation in the form of code execution in many cases. Is
>> there another way to get code execution via that bubblewrap/flatpak bug
>> with this feature implemented? As far as I can tell, there isn't. It's a
>> problem even with this feature but a significantly less serious one.
>
> This patch solves a real problem when userspace does things wrong. For
> those that do not want it, a sysctl exists (and is even default off).
> Arguments about how userspace needs to be fixed is a total red
> herring. Like symlink protections before, this should be available for
> those that want it because it solves an interface problem that gets
> regularly misused and causes real damage. The kernel has a
> responsibility to protect userspace.
>
> As Daniel mentions, there is a history of mistakes that appear to be
> becoming even more common:
> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=TIOCSTI
>
> There are people who want this feature that do not care about xemacs
> breaking. The default cannot be enabled because of the golden rule of
> never breaking userspace, but entirely refusing to fix a regularly
> misused feature is wrong-headed. We must accept that not only are bug
> lifetimes long, but that bugs will keep getting reintroduced. When
> there is a chance to kill a class of bugs or exploit techniques, it's
> the kernel responsibility to do so. This is a clear case of that, and
> the solution is concise.

True but what is usage of TIOCSTI that is wrong in these CVE.   Is it
not when the returned input values values to tty crosses process
boundaries.  Like if when process terminated everything the process
had pushed back to TTY and Input it has received was lost those CVE
would not be possible.

Could those exist CVE when exploit happens have CAP_SYS_ADMIN as the
process being used to break out the answer is yes.   So restricting
TIOCSTI to CAP_SYS_ADMIN could be pointless.   Remember you have suid
bit applications one of those might have  bug that someone is able to
exploit to use the TIOCSTI.   So pushing to CAP_SYS_ADMIN make exploit
rarer does not remove it.

Please note you see TIOCSTI using in libc when they implement
ungetc().   So this is something that is quite well used.   I see
ungetc as kind of a bad idea to be implemented kernel level going to
tty shareable between processes.

> If there is some better solution that the kernel can provide to
> mitigate processes misusing ttys, then by all means, we can add that
> too, but has nothing to do with refusing this change. This solves a
> specific problem that in many cases is the only path to privilege
> escalation (as Daniel mentioned). Refusing this change is nonsense.
> "Your car shouldn't have seat belts because maybe something will stab
> you through the windshield" isn't a reasonable argument to make.

Using cap_sys_admin as fix is like removing car windsheld because
vision is being blocked by a rock hitting it.

Kees the problem with accepting a security fix that is wrong the
proper change never gets worked on.

I am not saying there is not a real problem here.   The fix is not
push it to CAP_SYS_ADMIN.   Due to TIOCSTI that cross process and tty
boundaries been used in security breaks and limit applications that
uses use as either Administrator or as normal User means this ability
does not own in CAP_SYS_ADMIN either.

The same is true of obsolete function calls that have been shoved into
CAP_SYS_ADMIN already there comes point where no valid userspace
application is using that function.   At that point the only thing
using that function is exploits so then really CAP_SYS_ADMIN should
not have access to those obsolete functions.   There is a real need
for CAP_SYS_OBSOLETE.   If a program has to ahve CAP_SYS_OBSOLETE set
on it this means it using functionally that is known busted in some
way..

This is the biggest problem here.   There is no real agreement how we
exterminate/restrict flawed functions to progressive reduce the number
of applications and users who can access the flawed functions to allow
them to be fully disabled for 99.99 percent of people using systems.

That is what people are not getting CAP_SYS_ADMIN has too many users
to be counted and mitigation as well.

Yes we must not break userspace but we also must mitigate against
userspace issues.   We do need a clear rules on how to fix these
security problem user-space is allowed to be broken and of course made
part of the Linux kernel documentation.   Altering the binary is for
sure out because the person operating the system may not have that
right.   Placing a flag on a binary so it works I would see as
acceptable as long as that flag was not grant a stack of other
privileges that application would have never had before..

Peter Dolding
