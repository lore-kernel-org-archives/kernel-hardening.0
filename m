MIME-Version: 1.0
In-Reply-To: <1495045540.1619.1.camel@gmail.com>
References: <20170505232018.28846-1-matt@nmatt.com> <20170510212920.7f6bc5e6@alans-desktop>
 <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com> <20170515215752.4e9f3826@alans-desktop>
 <CANA3KFU6Aor=NjdC49XpX=h29vSpeiDNn78en7sbZFosAcntGw@mail.gmail.com>
 <5c5c9b06-d2ec-c2e5-3ea2-463f315428f6@nmatt.com> <CANA3KFUh6Q+Pq6Srh-dQv0gaRy4zUJAJcyGLYoDFH+MfTycp+A@mail.gmail.com>
 <1a1730f3-5378-1ce5-77a9-b9bc8cd5c90b@nmatt.com> <CAGXu5jJrEw1WOGniTV4Jhv_mO2zHxmXJqpzUs7BOUJNpCU1MNg@mail.gmail.com>
 <20170517174113.69d1cbaa@alans-desktop> <1495045540.1619.1.camel@gmail.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Wed, 17 May 2017 19:04:41 -0400
Message-ID: <CAFUG7CcUkajKfkPu7T+GSx-g+oew84GECG0rhkwWTPC-NxvCUA@mail.gmail.com>
Content-Type: multipart/alternative; boundary="f403045c764e3a7c13054fc05052"
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Daniel Micay <danielmicay@gmail.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Kees Cook <keescook@chromium.org>, Matt Brown <matt@nmatt.com>, Peter Dolding <oiaohm@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--f403045c764e3a7c13054fc05052
Content-Type: text/plain; charset="UTF-8"

To put a bit of a red team spin on this: if its not fixed in the kernel,
binaries/shellcode specifically written to abuse the functionality will be
introduced by the attacker to take advantage of the hole. Defense in depth
means mitigating each tier of the attacker's progression, not simply
blocking initial ingress/execution.
SELinux is not omnipresent, almost never properly configured, and from the
point of view of practical security in the critical infrastructures using
Linux, not an appropriate response when relating to kernel functionality -
"WONTFIX beacuause NOTMYPROBLEM" is what got us all here in the first
place.
Finally, far as compatibility goes, disabling the protective measure for
the small segment of valid violators of proper use semantics handles the
concern - either system-wide as a sysctl, or via the TPE implementation
itself.

Can we all agree that the primary purpose of this effort is to harden the
system, with cowtowing to "improperly implemented consumers" reduced to
only the most common cases which would actually impede users?
If we dont, it wont be long till elephant tears about Wine and VirtualBox
flood these discussions.

On Wed, May 17, 2017 at 2:25 PM, Daniel Micay <danielmicay@gmail.com> wrote:

> On Wed, 2017-05-17 at 17:41 +0100, Alan Cox wrote:
> > > If we're adjusting applications, they should be made to avoid
> > > TIOSCTI
> > > completely. This looks to me a lot like the symlink restrictions:
> > > yes,
> > > userspace should be fixed to the do the right thing, but why not
> > > provide support to userspace to avoid the problem entirely?
> >
> > We do it's called pty/tty. There isn't any other way to do this
> > correctly
> > because TIOCSTI is just one hundreds of things the attacker can do to
> > make your life miserable in the case you create a child process of
> > lower
> > security privilege and give it your tty file handle or worse (like
> > some
> > container crapware) your X11 socket fd.
> >
> > Does it really matter any more or less if I reprogram your enter key,
> > use
> > TIOCSTI, set the baud rate, change all your fonts ?
> >
> > The mainstream tools like sudo get this right (*). Blocking TIOCSTI
> > fixes
> > nothing and breaks apps. If it magically fixed the problem it might
> > make
> > sense but it doesn't. You actually have to get an adult to write the
> > relevant code.
>
> It gets it right because it was reported as a vulnerability and fixed,
> which is the cycle many of these tools have gone through. It looks like
> sudo and coreutils / shadow su were fixed in 2005, but there are more of
> these tools.
>
> CVE-2005-4890 (coreutils su, shadow su, sudo), CVE-2016-7545 (SELinux
> sandbox utility), CVE-2016-2781 (chroot --userspec), CVE-2016-2779
> (util-linux runuser), CVE-2016-2568 (pkexec)
>
> I am not sure if the pkexec vulnerability is even fixed:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1300746
>
> CVE-2017-5226 is for bubblewrap/flatpak this year, and I'm sure there
> were a lot more as I didn't bother to dig very deep.
>
> I completely agree that it should be solved by doing things properly in
> each application. However, it isn't solved properly everywhere and each
> new application is making the same mistake. Providing this feature does
> not break anything that people use in practice and it doesn't need to
> solve every issue to be quite useful, it only needs to prevent local
> privilege escalation in the form of code execution in many cases. Is
> there another way to get code execution via that bubblewrap/flatpak bug
> with this feature implemented? As far as I can tell, there isn't. It's a
> problem even with this feature but a significantly less serious one.
>



-- 
Boris Lukashev
Systems Architect
Semper Victus

--f403045c764e3a7c13054fc05052
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>To put a bit of a red team spin on thi=
s: if its not fixed in the kernel, binaries/shellcode specifically written =
to abuse the functionality will be introduced by the attacker to take advan=
tage of the hole. Defense in depth means mitigating each tier of the attack=
er&#39;s progression, not simply blocking initial ingress/execution.<br></d=
iv>SELinux is not omnipresent, almost never properly configured, and from t=
he point of view of practical security in the critical infrastructures usin=
g Linux, not an appropriate response when relating to kernel functionality =
- &quot;WONTFIX beacuause NOTMYPROBLEM&quot; is what got us all here in the=
 first place. <br></div>Finally, far as compatibility goes, disabling the p=
rotective measure for the small segment of valid violators of proper use se=
mantics handles the concern - either system-wide as a sysctl, or via the TP=
E implementation itself.<br><br></div>Can we all agree that the primary pur=
pose of this effort is to harden the system, with cowtowing to &quot;improp=
erly implemented consumers&quot; reduced to only the most common cases whic=
h would actually impede users?<br></div>If we dont, it wont be long till el=
ephant tears about Wine and VirtualBox flood these discussions.<br></div><d=
iv class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed, May 17, 201=
7 at 2:25 PM, Daniel Micay <span dir=3D"ltr">&lt;<a href=3D"mailto:danielmi=
cay@gmail.com" target=3D"_blank">danielmicay@gmail.com</a>&gt;</span> wrote=
:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, 2017-05-17 at =
17:41 +0100, Alan Cox wrote:<br>
&gt; &gt; If we&#39;re adjusting applications, they should be made to avoid=
<br>
&gt; &gt; TIOSCTI<br>
&gt; &gt; completely. This looks to me a lot like the symlink restrictions:=
<br>
&gt; &gt; yes,<br>
&gt; &gt; userspace should be fixed to the do the right thing, but why not<=
br>
&gt; &gt; provide support to userspace to avoid the problem entirely?<br>
&gt;<br>
&gt; We do it&#39;s called pty/tty. There isn&#39;t any other way to do thi=
s<br>
&gt; correctly<br>
&gt; because TIOCSTI is just one hundreds of things the attacker can do to<=
br>
&gt; make your life miserable in the case you create a child process of<br>
&gt; lower<br>
&gt; security privilege and give it your tty file handle or worse (like<br>
&gt; some<br>
&gt; container crapware) your X11 socket fd.<br>
&gt;<br>
&gt; Does it really matter any more or less if I reprogram your enter key,<=
br>
&gt; use<br>
&gt; TIOCSTI, set the baud rate, change all your fonts ?<br>
&gt;<br>
&gt; The mainstream tools like sudo get this right (*). Blocking TIOCSTI<br=
>
&gt; fixes<br>
&gt; nothing and breaks apps. If it magically fixed the problem it might<br=
>
&gt; make<br>
&gt; sense but it doesn&#39;t. You actually have to get an adult to write t=
he<br>
&gt; relevant code.<br>
<br>
</span>It gets it right because it was reported as a vulnerability and fixe=
d,<br>
which is the cycle many of these tools have gone through. It looks like<br>
sudo and coreutils / shadow su were fixed in 2005, but there are more of<br=
>
these tools.<br>
<br>
CVE-2005-4890 (coreutils su, shadow su, sudo), CVE-2016-7545 (SELinux<br>
sandbox utility), CVE-2016-2781 (chroot --userspec), CVE-2016-2779<br>
(util-linux runuser), CVE-2016-2568 (pkexec)<br>
<br>
I am not sure if the pkexec vulnerability is even fixed:<br>
<br>
<a href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D1300746" rel=3D"no=
referrer" target=3D"_blank">https://bugzilla.redhat.com/<wbr>show_bug.cgi?i=
d=3D1300746</a><br>
<br>
CVE-2017-5226 is for bubblewrap/flatpak this year, and I&#39;m sure there<b=
r>
were a lot more as I didn&#39;t bother to dig very deep.<br>
<br>
I completely agree that it should be solved by doing things properly in<br>
each application. However, it isn&#39;t solved properly everywhere and each=
<br>
new application is making the same mistake. Providing this feature does<br>
not break anything that people use in practice and it doesn&#39;t need to<b=
r>
solve every issue to be quite useful, it only needs to prevent local<br>
privilege escalation in the form of code execution in many cases. Is<br>
there another way to get code execution via that bubblewrap/flatpak bug<br>
with this feature implemented? As far as I can tell, there isn&#39;t. It&#3=
9;s a<br>
problem even with this feature but a significantly less serious one.<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=
=3D"ltr">Boris Lukashev<br>Systems Architect<br>Semper Victus<br></div></di=
v></div></div>
</div>

--f403045c764e3a7c13054fc05052--
