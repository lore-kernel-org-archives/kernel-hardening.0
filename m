Date: Mon, 15 May 2017 06:45:14 +0200
In-Reply-To: <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
References: <20170505232018.28846-1-matt@nmatt.com> <20170510212920.7f6bc5e6@alans-desktop> <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="----BVPQGWKROEJFNGYAADLOMWD4BZZ3YO"
Content-Transfer-Encoding: 7bit
From: Nicolas Belouin <nicolas@belouin.fr>
Message-ID: <0093C52B-B3D8-40A7-AB62-727861C4B261@belouin.fr>
Subject: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI ioctl require CAP_SYS_ADMIN
To: kernel-hardening@lists.openwall.com, Matt Brown <matt@nmatt.com>
Cc: serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, jmorris@namei.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>
List-ID: <kernel-hardening.lists.openwall.com>

------BVPQGWKROEJFNGYAADLOMWD4BZZ3YO
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

I haven't read your patch, but from its description, are you sure CAP_SYS_A=
DMIN is the right choice for such behavior ?
CAP_SYS_ADMIN is, from my point of view, a too broadly used capability=2E
I think CAP_SYS_TTY_CONFIG is a more appropriate capability for that parti=
cular purpose=2E

On May 13, 2017 9:52:58 PM GMT+02:00, Matt Brown <matt@nmatt=2Ecom> wrote:
>On 05/10/2017 04:29 PM, Alan Cox wrote:
>> On Fri,  5 May 2017 19:20:16 -0400
>> Matt Brown <matt@nmatt=2Ecom> wrote:
>>
>>> This patchset introduces the tiocsti_restrict sysctl, whose default
>is
>>> controlled via CONFIG_SECURITY_TIOCSTI_RESTRICT=2E When activated,
>this
>>> control restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN
>users=2E
>>>
>>> This patch was inspired from GRKERNSEC_HARDEN_TTY=2E
>>>
>>> This patch would have prevented
>>> https://bugzilla=2Eredhat=2Ecom/show_bug=2Ecgi?id=3D1411256 under the
>following
>>> conditions:
>>> * non-privileged container
>>> * container run inside new user namespace
>>>
>>> Possible effects on userland:
>>>
>>> There could be a few user programs that would be effected by this
>>> change=2E
>>> See: <https://codesearch=2Edebian=2Enet/search?q=3Dioctl%5C%28=2E*TIOC=
STI>
>>> notable programs are: agetty, csh, xemacs and tcsh
>>>
>>> However, I still believe that this change is worth it given that the
>>> Kconfig defaults to n=2E
>>
>> And it still doesn't deal with the fact that there are hundreds of
>other
>> ways to annoy the owner of a tty if it's passed to a lower privilege
>> child from framebuffer reprogramming through keyboard remaps=2E
>>
>> The proper way to handle those cases is to create a pty/tty pair and
>use
>> that=2E Your patch is pure snake oil and if anything implies safety
>that
>> doesn't exist=2E
>>
>
>I'm not implying that my patch is supposed to provide safety for
>"hundreds of other" issues=2E I'm looking to provide a way to lock down a
>single TTY ioctl that has caused real security issues to arise=2E For
>this reason, it's completely incorrect to say that this feature is
>snake oil=2E My patch does exactly what it claims to do=2E No more no les=
s=2E
>
>> In addition your change to allow it to be used by root in the guest
>> completely invalidates any protection you have because I can push
>>
>> "rm -rf /\n"
>>
>> as root in my namespace and exit
>>
>> The tty buffers are not flushed across the context change so the
>shell
>> you return to gets the input and oh dear=2E=2E=2E=2E
>
>This is precisely what my patch prevents! With my protection enabled, a
>container will only be able to use the TIOCSTI ioctl on a tty if that
>container has CAP_SYS_ADMIN in the user namespace in which the tty was
>created=2E
>
>>
>> Alan
>>

Nicolas
------BVPQGWKROEJFNGYAADLOMWD4BZZ3YO
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body>I haven&#39;t read your patch, but from its descri=
ption, are you sure CAP_SYS_ADMIN is the right choice for such behavior ?<b=
r>
CAP_SYS_ADMIN is, from my point of view, a too broadly used capability=2E<=
br>
I think CAP_SYS_TTY_CONFIG is a more appropriate capability for that parti=
cular purpose=2E<br><br><div class=3D"gmail_quote">On May 13, 2017 9:52:58 =
PM GMT+02:00, Matt Brown &lt;matt@nmatt=2Ecom&gt; wrote:<blockquote class=
=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt 0=2E8ex; border-left: 1px sol=
id rgb(204, 204, 204); padding-left: 1ex;">
<pre class=3D"k9mail">On 05/10/2017 04:29 PM, Alan Cox wrote:<br /><blockq=
uote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-lef=
t: 1px solid #729fcf; padding-left: 1ex;"> On Fri,  5 May 2017 19:20:16 -04=
00<br /> Matt Brown &lt;matt@nmatt=2Ecom&gt; wrote:<br /><br /><blockquote =
class=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1p=
x solid #ad7fa8; padding-left: 1ex;"> This patchset introduces the tiocsti_=
restrict sysctl, whose default is<br /> controlled via CONFIG_SECURITY_TIOC=
STI_RESTRICT=2E When activated, this<br /> control restricts all TIOCSTI io=
ctl calls from non CAP_SYS_ADMIN users=2E<br /><br /> This patch was inspir=
ed from GRKERNSEC_HARDEN_TTY=2E<br /><br /> This patch would have prevented=
<br /> <a href=3D"https://bugzilla=2Eredhat=2Ecom/show_bug=2Ecgi?id=3D14112=
56">https://bugzilla=2Eredhat=2Ecom/show_bug=2Ecgi?id=3D1411256</a> under t=
he following<br /> conditions:<br /> * non-privileged container<br /> * con=
tainer run inside new user namespace<br /><br /> Possible effects on userla=
nd:<br /><br /> There could be a few user programs that would be effected b=
y this<br /> change=2E<br /> See: &lt;<a href=3D"https://codesearch=2Edebia=
n=2Enet/search?q=3Dioctl%5C%28=2E*TIOCSTI">https://codesearch=2Edebian=2Ene=
t/search?q=3Dioctl%5C%28=2E*TIOCSTI</a>&gt;<br /> notable programs are: age=
tty, csh, xemacs and tcsh<br /><br /> However, I still believe that this ch=
ange is worth it given that the<br /> Kconfig defaults to n=2E<br /></block=
quote><br /> And it still doesn't deal with the fact that there are hundred=
s of other<br /> ways to annoy the owner of a tty if it's passed to a lower=
 privilege<br /> child from framebuffer reprogramming through keyboard rema=
ps=2E<br /><br /> The proper way to handle those cases is to create a pty/t=
ty pair and use<br /> that=2E Your patch is pure snake oil and if anything =
implies safety that<br /> doesn't exist=2E</blockquote><br /><br />I'm not =
implying that my patch is supposed to provide safety for<br />&quot;hundred=
s of other&quot; issues=2E I'm looking to provide a way to lock down a<br /=
>single TTY ioctl that has caused real security issues to arise=2E For<br /=
>this reason, it's completely incorrect to say that this feature is<br />sn=
ake oil=2E My patch does exactly what it claims to do=2E No more no less=2E=
<br /><br /><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex =
0=2E8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"> In addition y=
our change to allow it to be used by root in the guest<br /> completely inv=
alidates any protection you have because I can push<br /><br /> &quot;rm -r=
f /\n&quot;<br /><br /> as root in my namespace and exit<br /><br /> The tt=
y buffers are not flushed across the context change so the shell<br /> you =
return to gets the input and oh dear=2E=2E=2E=2E<br /></blockquote><br />Th=
is is precisely what my patch prevents! With my protection enabled, a<br />=
container will only be able to use the TIOCSTI ioctl on a tty if that<br />=
container has CAP_SYS_ADMIN in the user namespace in which the tty was<br /=
>created=2E<br /><br /><blockquote class=3D"gmail_quote" style=3D"margin: 0=
pt 0pt 1ex 0=2E8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"><br=
 /> Alan</blockquote><br /></pre></blockquote></div><br>
Nicolas</body></html>
------BVPQGWKROEJFNGYAADLOMWD4BZZ3YO--
