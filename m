Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <776ce31c-5268-8476-b6b1-989aa462327d@gmail.com>
References: <776ce31c-5268-8476-b6b1-989aa462327d@gmail.com>
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Date: Wed, 7 Dec 2016 16:54:14 +0100
Message-ID: <CAJfZ7==mdOFbrhuYcKX5gnHk9OHVFNUSj0XGiTZrmWEDRwMMuw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11403b6464351a054313881b
Subject: Re: [kernel-hardening] Picking "Write a plugin to do format string
 warnings correctly"
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a11403b6464351a054313881b
Content-Type: text/plain; charset=UTF-8

On Wed, Dec 7, 2016 at 12:21 AM, Ruslan Kuprieiev <kupruser@gmail.com>
wrote:

> Hi!
>
> After watching a bunch of talks from Kees about security, I've finally
> decided to
> try to participate in KSPP.
>
> If it's not taken, I would like to start with this task:
>
>      Write a plugin to do format string warnings correctly (gcc's
> -Wformat-security is bad about const strings)
>
> Unfortunately, I wasn't able to find any details about this task. Could
> someone provide some info about it, please?
>

Hello,
I do not know either what this task is about. Nevertheless I started
writing a plugin to check the %p... format strings in the kernel by
implementing a white-list of types associated to a format (eg. %pd used
with "struct dentry*", %pIS with a sockaddr pointer, etc.). This
work-in-progress plugin is available on
https://github.com/fishilico/linux-patches/blob/master/patches/plugin/Add-printk-format-checker-plugin.patch
and I have used it to find bugs like the one fixed in
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7703773ef1d85b40433902a8da20167331597e4a
.

The main reason why my plugin is still "work-in-progress / not ready for
proper submission" is that it does not support casts well. For example if p
is a void* variable, my plugin sees printk("%s", (char *)p) as using %s on
a void*. I have not yet found how I need to modify the plugin to get the
type-casting information (I may need to specify a suitable gcc pass in the
plugin).

Anyway, as this seems to be something different from "gcc's
-Wformat-security is bad about const strings", the task may be about
something else.

On a related subject, I have also written some patches in order to
automatically silent -Wformat-security warnings when using a variable as a
format string. For example some code in the kernel like to call
request_module(module_name) where module_name is a non-const variable.
Instead of "fixing" such a call with request_module("%s", module_name) I am
working on two patches which define macros to make
request_module(module_name) call a function which does not use a format
string parameter (
https://github.com/fishilico/linux-patches/blob/master/patches/maybe_upstreamable/Allow-overiding-functions-depending-on-the.patch
and
https://github.com/fishilico/linux-patches/blob/master/patches/maybe_upstreamable/Make-request_module-callable-without-a-format.patch).
Would such patches be appreciated in the kernel?

Thanks,
Nicolas

--001a11403b6464351a054313881b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On W=
ed, Dec 7, 2016 at 12:21 AM, Ruslan Kuprieiev <span dir=3D"ltr">&lt;<a href=
=3D"mailto:kupruser@gmail.com" target=3D"_blank">kupruser@gmail.com</a>&gt;=
</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px=
 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi!<br>
<br>
After watching a bunch of talks from Kees about security, I&#39;ve finally =
decided to<br>
try to participate in KSPP.<br>
<br>
If it&#39;s not taken, I would like to start with this task:<br>
<br>
=C2=A0 =C2=A0 =C2=A0Write a plugin to do format string warnings correctly (=
gcc&#39;s -Wformat-security is bad about const strings)<br>
<br>
Unfortunately, I wasn&#39;t able to find any details about this task. Could=
 someone provide some info about it, please?<br></blockquote><div><br></div=
><div>Hello,</div><div>I do not know either what this task is about. Nevert=
heless I started writing a plugin to check the %p... format strings in the =
kernel by implementing a white-list of types associated to a format (eg. %p=
d used with &quot;struct=C2=A0dentry*&quot;, %pIS with a sockaddr pointer, =
etc.). This work-in-progress plugin is available on=C2=A0<a href=3D"https:/=
/github.com/fishilico/linux-patches/blob/master/patches/plugin/Add-printk-f=
ormat-checker-plugin.patch">https://github.com/fishilico/linux-patches/blob=
/master/patches/plugin/Add-printk-format-checker-plugin.patch</a> and I hav=
e used it to find bugs like the one fixed in <a href=3D"https://git.kernel.=
org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3D7703773ef1d85b404=
33902a8da20167331597e4a">https://git.kernel.org/cgit/linux/kernel/git/torva=
lds/linux.git/commit/?id=3D7703773ef1d85b40433902a8da20167331597e4a</a>.</d=
iv><div><br></div><div>The main reason why my plugin is still &quot;work-in=
-progress / not ready for proper submission&quot; is that it does not suppo=
rt casts well. For example if p is a void* variable, my plugin sees printk(=
&quot;%s&quot;, (char *)p) as using %s on a void*. I have not yet found how=
 I need to modify the plugin to get the type-casting information (I may nee=
d to specify a suitable gcc pass in the plugin).</div><div><br></div><div>A=
nyway, as this seems to be something different from &quot;gcc&#39;s -Wforma=
t-security is bad about const strings&quot;, the task may be about somethin=
g else.</div><div><br></div><div>On a related subject, I have also written =
some patches in order to automatically silent -Wformat-security warnings wh=
en using a variable as a format string. For example some code in the kernel=
 like to call request_module(module_name) where module_name is a non-const =
variable. Instead of &quot;fixing&quot; such a call with request_module(&qu=
ot;%s&quot;, module_name) I am working on two patches which define macros t=
o make request_module(module_name) call a function which does not use a for=
mat string parameter (<a href=3D"https://github.com/fishilico/linux-patches=
/blob/master/patches/maybe_upstreamable/Allow-overiding-functions-depending=
-on-the.patch">https://github.com/fishilico/linux-patches/blob/master/patch=
es/maybe_upstreamable/Allow-overiding-functions-depending-on-the.patch</a> =
and=C2=A0<a href=3D"https://github.com/fishilico/linux-patches/blob/master/=
patches/maybe_upstreamable/Make-request_module-callable-without-a-format.pa=
tch">https://github.com/fishilico/linux-patches/blob/master/patches/maybe_u=
pstreamable/Make-request_module-callable-without-a-format.patch</a>). Would=
 such patches be appreciated in the kernel?</div><div><br></div><div>Thanks=
,</div><div>Nicolas</div><div><br></div></div></div></div>

--001a11403b6464351a054313881b--
