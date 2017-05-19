MIME-Version: 1.0
In-Reply-To: <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
References: <20170505232018.28846-1-matt@nmatt.com> <20170510212920.7f6bc5e6@alans-desktop>
 <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com> <20170515215752.4e9f3826@alans-desktop>
 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com> <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com> <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
 <20170517174113.69d1cbaa@alans-desktop> <1495045540.1619.1.camel@gmail.com>
 <CAGXu5jL9GUyVYf3d+13UE7UHd+CvUzVwasyCfUmF+ykaY5rpOQ@mail.gmail.com> <CANA3KFWF-=6AWZKAc1ijyoL5vRAwPnwngZZEP9=5+AFgnMv1rg@mail.gmail.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Fri, 19 May 2017 00:08:58 -0400
Message-ID: <CAFUG7CdZ4h9YUOcWWNVjZ-0utfkfGDUNfZEwK4inaK3vpY++aA@mail.gmail.com>
Content-Type: multipart/alternative; boundary="f403045c505644b3e6054fd8ae19"
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Peter Dolding <oiaohm@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matt Brown <matt@nmatt.com>, "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--f403045c505644b3e6054fd8ae19
Content-Type: text/plain; charset="UTF-8"

How about a middle-ground wherein the mitigation, with the sysctl @ 0,
spams dmesg resulting in bug reports being filed by concerned users against
the offending application mentioned in the log? If the user or distribution
desires (say they dont have suid binaries - look at Copperhead), they can
enable the sysctl and enable mitigation.
>From what little i understand of security concerns in Linux' history,
compatibility seems to be the deciding factor in determining if and how
defenses are implemented. Is this not exactly what tunable sysctls are for
- providing new functionality which can be enabled or disabled allowing
adjacent components time to adjust to the change and make proper use of it?
This permits the modification, adjacent/dependent functionality, and a
measure of compatibility for legacy consumers.
In the nominal discussion about compatibility and security or performance
and security, the notion of expediency in delivering functionality is
rarely as much a factor as it is in this effort. There are a lot of users
out there who went from having some peace of mind from what they were
getting with grsec to loss and confusion. There are also use cases where
the consequences of leaking information or suffering compromise are outside
the realm of financial loss. I'm sure everyone wants a proper workflow
informing adjacent efforts/consumers and maintaining the maximum level
compatibility possible. Waiting for everyone to get on board, including
projects where committers may check their email twice a year, isnt viable
if the objective is to protect systems and people today. There's also the
bitrot concern...
Review of these patches may go faster if its a bit less academic in terms
of finding edge cases in potential consumers, and a bit more focused on the
content and defensive measures provided - or their flaws and weaknesses as
implemented, all of which should either inform the pull request or future
efforts on the existing codebase. From an engineering standpoint - if we
want to find the consumer problems for these changes (in kernel or
userspace), we can start by building a small army of build and test bots to
build on and run in the most common distributions, fuzzing their kernels
and userspace binaries, then feeding us output, stack traces, and other
actionable intelligence.


On Thu, May 18, 2017 at 10:48 PM, Peter Dolding <oiaohm@gmail.com> wrote:

> On Thu, May 18, 2017 at 1:18 PM, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, May 17, 2017 at 11:25 AM, Daniel Micay <danielmicay@gmail.com>
> wrote:
> >> On Wed, 2017-05-17 at 17:41 +0100, Alan Cox wrote:
> >>> > If we're adjusting applications, they should be made to avoid
> >>> > TIOSCTI
> >>> > completely. This looks to me a lot like the symlink restrictions:
> >>> > yes,
> >>> > userspace should be fixed to the do the right thing, but why not
> >>> > provide support to userspace to avoid the problem entirely?
> >>>
> >>> We do it's called pty/tty. There isn't any other way to do this
> >>> correctly
> >>> because TIOCSTI is just one hundreds of things the attacker can do to
> >>> make your life miserable in the case you create a child process of
> >>> lower
> >>> security privilege and give it your tty file handle or worse (like
> >>> some
> >>> container crapware) your X11 socket fd.
> >>>
> >>> Does it really matter any more or less if I reprogram your enter key,
> >>> use
> >>> TIOCSTI, set the baud rate, change all your fonts ?
> >>>
> >>> The mainstream tools like sudo get this right (*). Blocking TIOCSTI
> >>> fixes
> >>> nothing and breaks apps. If it magically fixed the problem it might
> >>> make
> >>> sense but it doesn't. You actually have to get an adult to write the
> >>> relevant code.
> >>
> >> It gets it right because it was reported as a vulnerability and fixed,
> >> which is the cycle many of these tools have gone through. It looks like
> >> sudo and coreutils / shadow su were fixed in 2005, but there are more of
> >> these tools.
> >>
> >> CVE-2005-4890 (coreutils su, shadow su, sudo), CVE-2016-7545 (SELinux
> >> sandbox utility), CVE-2016-2781 (chroot --userspec), CVE-2016-2779
> >> (util-linux runuser), CVE-2016-2568 (pkexec)
> >>
> >> I am not sure if the pkexec vulnerability is even fixed:
> >>
> >> https://bugzilla.redhat.com/show_bug.cgi?id=1300746
> >>
> >> CVE-2017-5226 is for bubblewrap/flatpak this year, and I'm sure there
> >> were a lot more as I didn't bother to dig very deep.
> >>
> >> I completely agree that it should be solved by doing things properly in
> >> each application. However, it isn't solved properly everywhere and each
> >> new application is making the same mistake. Providing this feature does
> >> not break anything that people use in practice and it doesn't need to
> >> solve every issue to be quite useful, it only needs to prevent local
> >> privilege escalation in the form of code execution in many cases. Is
> >> there another way to get code execution via that bubblewrap/flatpak bug
> >> with this feature implemented? As far as I can tell, there isn't. It's a
> >> problem even with this feature but a significantly less serious one.
> >
> > This patch solves a real problem when userspace does things wrong. For
> > those that do not want it, a sysctl exists (and is even default off).
> > Arguments about how userspace needs to be fixed is a total red
> > herring. Like symlink protections before, this should be available for
> > those that want it because it solves an interface problem that gets
> > regularly misused and causes real damage. The kernel has a
> > responsibility to protect userspace.
> >
> > As Daniel mentions, there is a history of mistakes that appear to be
> > becoming even more common:
> > http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=TIOCSTI
> >
> > There are people who want this feature that do not care about xemacs
> > breaking. The default cannot be enabled because of the golden rule of
> > never breaking userspace, but entirely refusing to fix a regularly
> > misused feature is wrong-headed. We must accept that not only are bug
> > lifetimes long, but that bugs will keep getting reintroduced. When
> > there is a chance to kill a class of bugs or exploit techniques, it's
> > the kernel responsibility to do so. This is a clear case of that, and
> > the solution is concise.
>
> True but what is usage of TIOCSTI that is wrong in these CVE.   Is it
> not when the returned input values values to tty crosses process
> boundaries.  Like if when process terminated everything the process
> had pushed back to TTY and Input it has received was lost those CVE
> would not be possible.
>
> Could those exist CVE when exploit happens have CAP_SYS_ADMIN as the
> process being used to break out the answer is yes.   So restricting
> TIOCSTI to CAP_SYS_ADMIN could be pointless.   Remember you have suid
> bit applications one of those might have  bug that someone is able to
> exploit to use the TIOCSTI.   So pushing to CAP_SYS_ADMIN make exploit
> rarer does not remove it.
>
> Please note you see TIOCSTI using in libc when they implement
> ungetc().   So this is something that is quite well used.   I see
> ungetc as kind of a bad idea to be implemented kernel level going to
> tty shareable between processes.
>
> > If there is some better solution that the kernel can provide to
> > mitigate processes misusing ttys, then by all means, we can add that
> > too, but has nothing to do with refusing this change. This solves a
> > specific problem that in many cases is the only path to privilege
> > escalation (as Daniel mentioned). Refusing this change is nonsense.
> > "Your car shouldn't have seat belts because maybe something will stab
> > you through the windshield" isn't a reasonable argument to make.
>
> Using cap_sys_admin as fix is like removing car windsheld because
> vision is being blocked by a rock hitting it.
>
> Kees the problem with accepting a security fix that is wrong the
> proper change never gets worked on.
>
> I am not saying there is not a real problem here.   The fix is not
> push it to CAP_SYS_ADMIN.   Due to TIOCSTI that cross process and tty
> boundaries been used in security breaks and limit applications that
> uses use as either Administrator or as normal User means this ability
> does not own in CAP_SYS_ADMIN either.
>
> The same is true of obsolete function calls that have been shoved into
> CAP_SYS_ADMIN already there comes point where no valid userspace
> application is using that function.   At that point the only thing
> using that function is exploits so then really CAP_SYS_ADMIN should
> not have access to those obsolete functions.   There is a real need
> for CAP_SYS_OBSOLETE.   If a program has to ahve CAP_SYS_OBSOLETE set
> on it this means it using functionally that is known busted in some
> way..
>
> This is the biggest problem here.   There is no real agreement how we
> exterminate/restrict flawed functions to progressive reduce the number
> of applications and users who can access the flawed functions to allow
> them to be fully disabled for 99.99 percent of people using systems.
>
> That is what people are not getting CAP_SYS_ADMIN has too many users
> to be counted and mitigation as well.
>
> Yes we must not break userspace but we also must mitigate against
> userspace issues.   We do need a clear rules on how to fix these
> security problem user-space is allowed to be broken and of course made
> part of the Linux kernel documentation.   Altering the binary is for
> sure out because the person operating the system may not have that
> right.   Placing a flag on a binary so it works I would see as
> acceptable as long as that flag was not grant a stack of other
> privileges that application would have never had before..
>
> Peter Dolding
>



-- 
Boris Lukashev
Systems Architect
Semper Victus

--f403045c505644b3e6054fd8ae19
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>How about a middle-ground wherein the mitig=
ation, with the sysctl @ 0, spams dmesg resulting in bug reports being file=
d by concerned users against the offending application mentioned in the log=
? If the user or distribution desires (say they dont have suid binaries - l=
ook at Copperhead), they can enable the sysctl and enable mitigation.<br></=
div>From what little i understand of security concerns in Linux&#39; histor=
y, compatibility seems to be the deciding factor in determining if and how =
defenses are implemented. Is this not exactly what tunable sysctls are for =
- providing new functionality which can be enabled or disabled allowing adj=
acent components time to adjust to the change and make proper use of it? Th=
is permits the modification, adjacent/dependent functionality, and a measur=
e of compatibility for legacy consumers. <br></div>In the nominal discussio=
n about compatibility and security or performance and security, the notion =
of expediency in delivering functionality is rarely as much a factor as it =
is in this effort. There are a lot of users out there who went from having =
some peace of mind from what they were getting with grsec to loss and confu=
sion. There are also use cases where the consequences of leaking informatio=
n or suffering compromise are outside the realm of financial loss. I&#39;m =
sure everyone wants a proper workflow informing adjacent efforts/consumers =
and maintaining the maximum level compatibility possible. Waiting for every=
one to get on board, including projects where committers may check their em=
ail twice a year, isnt viable if the objective is to protect systems and pe=
ople today. There&#39;s also the bitrot concern...<br>Review of these patch=
es may go faster if its a bit less academic in terms of finding edge cases =
in potential consumers, and a bit more focused on the content and defensive=
 measures provided - or their flaws and weaknesses as implemented, all of w=
hich should either inform the pull request or future efforts on the existin=
g codebase. From an engineering standpoint - if we want to find the consume=
r problems for these changes (in kernel or userspace), we can start by buil=
ding a small army of build and test bots to build on and run in the most co=
mmon distributions, fuzzing their kernels and userspace binaries, then feed=
ing us output, stack traces, and other actionable intelligence. <br></div><=
br></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, =
May 18, 2017 at 10:48 PM, Peter Dolding <span dir=3D"ltr">&lt;<a href=3D"ma=
ilto:oiaohm@gmail.com" target=3D"_blank">oiaohm@gmail.com</a>&gt;</span> wr=
ote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"=
h5">On Thu, May 18, 2017 at 1:18 PM, Kees Cook &lt;<a href=3D"mailto:keesco=
ok@chromium.org">keescook@chromium.org</a>&gt; wrote:<br>
&gt; On Wed, May 17, 2017 at 11:25 AM, Daniel Micay &lt;<a href=3D"mailto:d=
anielmicay@gmail.com">danielmicay@gmail.com</a>&gt; wrote:<br>
&gt;&gt; On Wed, 2017-05-17 at 17:41 +0100, Alan Cox wrote:<br>
&gt;&gt;&gt; &gt; If we&#39;re adjusting applications, they should be made =
to avoid<br>
&gt;&gt;&gt; &gt; TIOSCTI<br>
&gt;&gt;&gt; &gt; completely. This looks to me a lot like the symlink restr=
ictions:<br>
&gt;&gt;&gt; &gt; yes,<br>
&gt;&gt;&gt; &gt; userspace should be fixed to the do the right thing, but =
why not<br>
&gt;&gt;&gt; &gt; provide support to userspace to avoid the problem entirel=
y?<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; We do it&#39;s called pty/tty. There isn&#39;t any other way t=
o do this<br>
&gt;&gt;&gt; correctly<br>
&gt;&gt;&gt; because TIOCSTI is just one hundreds of things the attacker ca=
n do to<br>
&gt;&gt;&gt; make your life miserable in the case you create a child proces=
s of<br>
&gt;&gt;&gt; lower<br>
&gt;&gt;&gt; security privilege and give it your tty file handle or worse (=
like<br>
&gt;&gt;&gt; some<br>
&gt;&gt;&gt; container crapware) your X11 socket fd.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Does it really matter any more or less if I reprogram your ent=
er key,<br>
&gt;&gt;&gt; use<br>
&gt;&gt;&gt; TIOCSTI, set the baud rate, change all your fonts ?<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; The mainstream tools like sudo get this right (*). Blocking TI=
OCSTI<br>
&gt;&gt;&gt; fixes<br>
&gt;&gt;&gt; nothing and breaks apps. If it magically fixed the problem it =
might<br>
&gt;&gt;&gt; make<br>
&gt;&gt;&gt; sense but it doesn&#39;t. You actually have to get an adult to=
 write the<br>
&gt;&gt;&gt; relevant code.<br>
&gt;&gt;<br>
&gt;&gt; It gets it right because it was reported as a vulnerability and fi=
xed,<br>
&gt;&gt; which is the cycle many of these tools have gone through. It looks=
 like<br>
&gt;&gt; sudo and coreutils / shadow su were fixed in 2005, but there are m=
ore of<br>
&gt;&gt; these tools.<br>
&gt;&gt;<br>
&gt;&gt; CVE-2005-4890 (coreutils su, shadow su, sudo), CVE-2016-7545 (SELi=
nux<br>
&gt;&gt; sandbox utility), CVE-2016-2781 (chroot --userspec), CVE-2016-2779=
<br>
&gt;&gt; (util-linux runuser), CVE-2016-2568 (pkexec)<br>
&gt;&gt;<br>
&gt;&gt; I am not sure if the pkexec vulnerability is even fixed:<br>
&gt;&gt;<br>
&gt;&gt; <a href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D1300746" =
rel=3D"noreferrer" target=3D"_blank">https://bugzilla.redhat.com/<wbr>show_=
bug.cgi?id=3D1300746</a><br>
&gt;&gt;<br>
&gt;&gt; CVE-2017-5226 is for bubblewrap/flatpak this year, and I&#39;m sur=
e there<br>
&gt;&gt; were a lot more as I didn&#39;t bother to dig very deep.<br>
&gt;&gt;<br>
&gt;&gt; I completely agree that it should be solved by doing things proper=
ly in<br>
&gt;&gt; each application. However, it isn&#39;t solved properly everywhere=
 and each<br>
&gt;&gt; new application is making the same mistake. Providing this feature=
 does<br>
&gt;&gt; not break anything that people use in practice and it doesn&#39;t =
need to<br>
&gt;&gt; solve every issue to be quite useful, it only needs to prevent loc=
al<br>
&gt;&gt; privilege escalation in the form of code execution in many cases. =
Is<br>
&gt;&gt; there another way to get code execution via that bubblewrap/flatpa=
k bug<br>
&gt;&gt; with this feature implemented? As far as I can tell, there isn&#39=
;t. It&#39;s a<br>
&gt;&gt; problem even with this feature but a significantly less serious on=
e.<br>
&gt;<br>
&gt; This patch solves a real problem when userspace does things wrong. For=
<br>
&gt; those that do not want it, a sysctl exists (and is even default off).<=
br>
&gt; Arguments about how userspace needs to be fixed is a total red<br>
&gt; herring. Like symlink protections before, this should be available for=
<br>
&gt; those that want it because it solves an interface problem that gets<br=
>
&gt; regularly misused and causes real damage. The kernel has a<br>
&gt; responsibility to protect userspace.<br>
&gt;<br>
&gt; As Daniel mentions, there is a history of mistakes that appear to be<b=
r>
&gt; becoming even more common:<br>
&gt; <a href=3D"http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=3DTIOCSTI" =
rel=3D"noreferrer" target=3D"_blank">http://cve.mitre.org/cgi-bin/<wbr>cvek=
ey.cgi?keyword=3DTIOCSTI</a><br>
&gt;<br>
&gt; There are people who want this feature that do not care about xemacs<b=
r>
&gt; breaking. The default cannot be enabled because of the golden rule of<=
br>
&gt; never breaking userspace, but entirely refusing to fix a regularly<br>
&gt; misused feature is wrong-headed. We must accept that not only are bug<=
br>
&gt; lifetimes long, but that bugs will keep getting reintroduced. When<br>
&gt; there is a chance to kill a class of bugs or exploit techniques, it&#3=
9;s<br>
&gt; the kernel responsibility to do so. This is a clear case of that, and<=
br>
&gt; the solution is concise.<br>
<br>
</div></div>True but what is usage of TIOCSTI that is wrong in these CVE.=
=C2=A0 =C2=A0Is it<br>
not when the returned input values values to tty crosses process<br>
boundaries.=C2=A0 Like if when process terminated everything the process<br=
>
had pushed back to TTY and Input it has received was lost those CVE<br>
would not be possible.<br>
<br>
Could those exist CVE when exploit happens have CAP_SYS_ADMIN as the<br>
process being used to break out the answer is yes.=C2=A0 =C2=A0So restricti=
ng<br>
TIOCSTI to CAP_SYS_ADMIN could be pointless.=C2=A0 =C2=A0Remember you have =
suid<br>
bit applications one of those might have=C2=A0 bug that someone is able to<=
br>
exploit to use the TIOCSTI.=C2=A0 =C2=A0So pushing to CAP_SYS_ADMIN make ex=
ploit<br>
rarer does not remove it.<br>
<br>
Please note you see TIOCSTI using in libc when they implement<br>
ungetc().=C2=A0 =C2=A0So this is something that is quite well used.=C2=A0 =
=C2=A0I see<br>
ungetc as kind of a bad idea to be implemented kernel level going to<br>
tty shareable between processes.<br>
<span class=3D""><br>
&gt; If there is some better solution that the kernel can provide to<br>
&gt; mitigate processes misusing ttys, then by all means, we can add that<b=
r>
&gt; too, but has nothing to do with refusing this change. This solves a<br=
>
&gt; specific problem that in many cases is the only path to privilege<br>
&gt; escalation (as Daniel mentioned). Refusing this change is nonsense.<br=
>
&gt; &quot;Your car shouldn&#39;t have seat belts because maybe something w=
ill stab<br>
&gt; you through the windshield&quot; isn&#39;t a reasonable argument to ma=
ke.<br>
<br>
</span>Using cap_sys_admin as fix is like removing car windsheld because<br=
>
vision is being blocked by a rock hitting it.<br>
<br>
Kees the problem with accepting a security fix that is wrong the<br>
proper change never gets worked on.<br>
<br>
I am not saying there is not a real problem here.=C2=A0 =C2=A0The fix is no=
t<br>
push it to CAP_SYS_ADMIN.=C2=A0 =C2=A0Due to TIOCSTI that cross process and=
 tty<br>
boundaries been used in security breaks and limit applications that<br>
uses use as either Administrator or as normal User means this ability<br>
does not own in CAP_SYS_ADMIN either.<br>
<br>
The same is true of obsolete function calls that have been shoved into<br>
CAP_SYS_ADMIN already there comes point where no valid userspace<br>
application is using that function.=C2=A0 =C2=A0At that point the only thin=
g<br>
using that function is exploits so then really CAP_SYS_ADMIN should<br>
not have access to those obsolete functions.=C2=A0 =C2=A0There is a real ne=
ed<br>
for CAP_SYS_OBSOLETE.=C2=A0 =C2=A0If a program has to ahve CAP_SYS_OBSOLETE=
 set<br>
on it this means it using functionally that is known busted in some<br>
way..<br>
<br>
This is the biggest problem here.=C2=A0 =C2=A0There is no real agreement ho=
w we<br>
exterminate/restrict flawed functions to progressive reduce the number<br>
of applications and users who can access the flawed functions to allow<br>
them to be fully disabled for 99.99 percent of people using systems.<br>
<br>
That is what people are not getting CAP_SYS_ADMIN has too many users<br>
to be counted and mitigation as well.<br>
<br>
Yes we must not break userspace but we also must mitigate against<br>
userspace issues.=C2=A0 =C2=A0We do need a clear rules on how to fix these<=
br>
security problem user-space is allowed to be broken and of course made<br>
part of the Linux kernel documentation.=C2=A0 =C2=A0Altering the binary is =
for<br>
sure out because the person operating the system may not have that<br>
right.=C2=A0 =C2=A0Placing a flag on a binary so it works I would see as<br=
>
acceptable as long as that flag was not grant a stack of other<br>
privileges that application would have never had before..<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Peter Dolding<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><=
div><div dir=3D"ltr">Boris Lukashev<br>Systems Architect<br>Semper Victus<b=
r></div></div></div></div>
</div>

--f403045c505644b3e6054fd8ae19--
