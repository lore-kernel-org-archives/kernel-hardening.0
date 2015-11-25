Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: saoret.one@gmail.com
From: =?UTF-8?B?U2FsdmEgUGVpcsOz?= <speirofr@gmail.com>
Date: Thu, 26 Nov 2015 00:14:16 +0100
Message-ID: <CAJpd-bFvTNQK=qGCPdnB1ec=yJ+jZuzaoR9pNbn01pgim=0aLg@mail.gmail.com>
Content-Type: multipart/mixed; boundary=047d7bb7089e35a5690525659f5b
Subject: [kernel-hardening] On techniques for preventing commit_creds() user-space abuse
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--047d7bb7089e35a5690525659f5b
Content-Type: multipart/alternative; boundary=047d7bb7089e35a5650525659f59

--047d7bb7089e35a5650525659f59
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

A complete version of the technique can be found at
http://speirofr.appspot.com/category/techniques/

# Analysis

Given the typical path for kernel exploitation is the
`commit_creds(prepare_kernel_cred(0))` being called from user space as
detailed in [References].
Why is not a check placed in commit_creds() that checks the return address
of the call to ensure the call is a legit one coming from kernel space?.

This blocks direct calls to commit_creds from user space,
however, it remains vulnerable to alternative exploit routes.
The alternatives to bypass this protection are:

- *Indirect jump*
An attacker can perform an indirect jump to a kernel location that does
the commit_creds() for him, but it complicates the task of the
attacker. To prevent indirect calls check the rest of the stack trace.

- *Direct override*
Another route to bypass would be to figure out the location of the
process creds in memory, and perform the change directly in memory,
but AFAIK SMAP and its ARM equivalent would deter this route.

Therefore, I started implementing some exploits for testing it,
and implemented the `commit_cred` protection checks technique to
check if it is viable for preventing the commit_creds abuse.

The [Implementation] provides a patch that implements the discussed
approach.
The [Evaluation] provides the tests performed showing it effectively
blocks commit_creds abuse from user space.

# Threat Model

The steps involved in commit_creds() exploits:

- Prepare user code to get root:
    user_addr =3D commit_creds(prepare_creds(0))

- Override kernel code with:
    kernel_struct.fptr =3D user_addr  (1st vuln point SMAP)

- Trigger a syscall that calls kernel_struct.fptr
    - Invoke syscall from user
    - Results in kernel_struct.fptr() being called
        Calls user-space code from kernel code
            (2nd vuln point this point we're already toasted SMEP)
        Then call commit_creds (kernel_code) from user
            At this point the can detect commit_creds called from user
           (3rd vuln: fix check return address)

# Implementation

The patch implementing the commit_creds() abuse prevention:

From: Salva Peir=C3=B3 <speirofr AT gmail.com>
Date: Wed, 25 Nov 2015 14:03:50 +0100
Subject: [PATCH] cred: Prevent commit_creds() user-space abuse

Signed-off-by: Salva Peir=C3=B3 <speirofr AT gmail.com>

---
 kernel/cred.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/cred.c b/kernel/cred.c
index 71179a0..7191db3 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -428,6 +428,13 @@ int commit_creds(struct cred *new)
        atomic_read(&new->usage),
        read_cred_subscribers(new));

+ /* block attempts to use commit_creds from user space */
+ if (__builtin_return_address(0) < PAGE_OFFSET) {
+ printk(KERN_ERR "CRED: BUG commit_creds called from user space\n");
+ WARN_ON(1);
+ return -1;
+ }
+

# Evaluation

The `dmesg(1)` output below shows the prevention of an exploit attempt
using [References] where commit_creds is being called from user-space.

[ 1979.132453] exploit[8549]: segfault at 0 ip 08048719 sp bf8ff430 error 6
in exploit[8048000+1000]
[ 1981.658186] BUG: commit_creds called from user space
[ 1981.658201] ------------[ cut here ]------------
[ 1981.658207] WARNING: CPU: 0 PID: 8552 at kernel/cred.c:436
commit_creds+0x1e5/0x210()
[ 1981.658209] Modules linked in: nullderef(O) nls_utf8 isofs udf crc_itu_

# References

- Much ado about NULL: Exploiting a kernel NULL dereference, by Nelson
Elhage
  https://blogs.oracle.com/ksplice/entry/much_ado_about_null_exploiting1.

--
Salva Peir=C3=B3 @ https://speirofr.appspot.com

--047d7bb7089e35a5650525659f59
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>A complete version of the technique can be found at</=
div><div><a href=3D"http://speirofr.appspot.com/category/techniques/">http:=
//speirofr.appspot.com/category/techniques/</a></div><div><br></div><div># =
Analysis</div><div><br></div><div>Given the typical path for kernel exploit=
ation is the</div><div>`commit_creds(prepare_kernel_cred(0))` being called =
from user space as</div><div>detailed in [References].</div><div>Why is not=
 a check placed in commit_creds() that checks the return address</div><div>=
of the call to ensure the call is a legit one coming from kernel space?.</d=
iv><div><br></div><div>This blocks direct calls to commit_creds from user s=
pace,</div><div>however, it remains vulnerable to alternative exploit route=
s.</div><div>The alternatives to bypass this protection are:</div><div><br>=
</div><div>- *Indirect jump*</div><div>An attacker can perform an indirect =
jump to a kernel location that does</div><div>the commit_creds() for him, b=
ut it complicates the task of the</div><div>attacker. To prevent indirect c=
alls check the rest of the stack trace.</div><div><br></div><div>- *Direct =
override*</div><div>Another route to bypass would be to figure out the loca=
tion of the</div><div>process creds in memory, and perform the change direc=
tly in memory,</div><div>but AFAIK SMAP and its ARM equivalent would deter =
this route.</div><div><br></div><div>Therefore, I started implementing some=
 exploits for testing it,</div><div>and implemented the `commit_cred` prote=
ction checks technique to</div><div>check if it is viable for preventing th=
e commit_creds abuse.</div><div><br></div><div>The [Implementation] provide=
s a patch that implements the discussed</div><div>approach.</div><div>The [=
Evaluation] provides the tests performed showing it effectively</div><div>b=
locks commit_creds abuse from user space.</div><div><br></div><div># Threat=
 Model</div><div><br></div><div>The steps involved in commit_creds() exploi=
ts:</div><div><br></div><div>- Prepare user code to get root:</div><div>=C2=
=A0 =C2=A0 user_addr =3D commit_creds(prepare_creds(0))</div><div><br></div=
><div>- Override kernel code with:</div><div>=C2=A0 =C2=A0 kernel_struct.fp=
tr =3D user_addr =C2=A0(1st vuln point SMAP)</div><div><br></div><div>- Tri=
gger a syscall that calls kernel_struct.fptr</div><div>=C2=A0 =C2=A0 - Invo=
ke syscall from user</div><div>=C2=A0 =C2=A0 - Results in kernel_struct.fpt=
r() being called</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 Calls user-space cod=
e from kernel code=C2=A0</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 (2nd vuln point this point we&#39;re already toasted SMEP)</div><div>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Then call commit_creds (kernel_code) from user<=
/div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 At this point the can d=
etect commit_creds called from user</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0(3rd vuln: fix check return address)</div><div><br></div><div>=
# Implementation</div><div><br></div><div>The patch implementing the commit=
_creds() abuse prevention:</div><div><br></div><div>From: Salva Peir=C3=B3 =
&lt;speirofr AT <a href=3D"http://gmail.com">gmail.com</a>&gt;</div><div>Da=
te: Wed, 25 Nov 2015 14:03:50 +0100</div><div>Subject: [PATCH] cred: Preven=
t commit_creds() user-space abuse</div><div><br></div><div>Signed-off-by: S=
alva Peir=C3=B3 &lt;speirofr AT <a href=3D"http://gmail.com">gmail.com</a>&=
gt;</div><div><br></div><div>---</div><div>=C2=A0kernel/cred.c | 7 +++++++<=
/div><div>=C2=A01 file changed, 7 insertions(+)</div><div><br></div><div>di=
ff --git a/kernel/cred.c b/kernel/cred.c</div><div>index 71179a0..7191db3 1=
00644</div><div>--- a/kernel/cred.c</div><div>+++ b/kernel/cred.c</div><div=
>@@ -428,6 +428,13 @@ int commit_creds(struct cred *new)</div><div>=C2=A0<s=
pan class=3D"" style=3D"white-space:pre">	</span> =C2=A0 =C2=A0 =C2=A0 atom=
ic_read(&amp;new-&gt;usage),</div><div>=C2=A0<span class=3D"" style=3D"whit=
e-space:pre">	</span> =C2=A0 =C2=A0 =C2=A0 read_cred_subscribers(new));</di=
v><div><br></div><div>+<span class=3D"" style=3D"white-space:pre">	</span>/=
* block attempts to use commit_creds from user space */</div><div>+<span cl=
ass=3D"" style=3D"white-space:pre">	</span>if (__builtin_return_address(0) =
&lt; PAGE_OFFSET) {</div><div>+<span class=3D"" style=3D"white-space:pre">	=
	</span>printk(KERN_ERR &quot;CRED: BUG commit_creds called from user space=
\n&quot;);</div><div>+<span class=3D"" style=3D"white-space:pre">		</span>W=
ARN_ON(1);</div><div>+<span class=3D"" style=3D"white-space:pre">		</span>r=
eturn -1;</div><div>+<span class=3D"" style=3D"white-space:pre">	</span>}</=
div><div>+</div><div><br></div><div># Evaluation</div><div><br></div><div>T=
he `dmesg(1)` output below shows the prevention of an exploit attempt</div>=
<div>using [References] where commit_creds is being called from user-space.=
</div><div><br></div><div>[ 1979.132453] exploit[8549]: segfault at 0 ip 08=
048719 sp bf8ff430 error 6 in exploit[8048000+1000]</div><div>[ 1981.658186=
] BUG: commit_creds called from user space</div><div>[ 1981.658201] -------=
-----[ cut here ]------------</div><div>[ 1981.658207] WARNING: CPU: 0 PID:=
 8552 at kernel/cred.c:436 commit_creds+0x1e5/0x210()</div><div>[ 1981.6582=
09] Modules linked in: nullderef(O) nls_utf8 isofs udf crc_itu_</div><div><=
br></div><div># References</div><div><br></div><div>- Much ado about NULL: =
Exploiting a kernel NULL dereference, by Nelson Elhage</div><div>=C2=A0 <a =
href=3D"https://blogs.oracle.com/ksplice/entry/much_ado_about_null_exploiti=
ng1">https://blogs.oracle.com/ksplice/entry/much_ado_about_null_exploiting1=
</a>.</div><div><br></div><div>--</div><div>Salva Peir=C3=B3 @ <a href=3D"h=
ttps://speirofr.appspot.com">https://speirofr.appspot.com</a></div></div>

--047d7bb7089e35a5650525659f59--

--047d7bb7089e35a5690525659f5b
Content-Type: text/x-patch; charset=UTF-8;
	name="0001-cred-Prevent-commit_creds-user-space-abuse.patch"
Content-Disposition: attachment;
	filename="0001-cred-Prevent-commit_creds-user-space-abuse.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ihffgf6e0

RnJvbSBhOTYxMzI0YWYxZjViNTQ4NGVmYTYwZjVjZjcwNzJkZTVjYmRhNjlkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/U2FsdmE9MjBQZWlyPUMzPUIzPz0gPHNwZWly
b2ZyQGdtYWlsLmNvbT4KRGF0ZTogV2VkLCAyNSBOb3YgMjAxNSAxNDowMzo1MCArMDEwMApTdWJq
ZWN0OiBbUEFUQ0hdIGNyZWQ6IFByZXZlbnQgY29tbWl0X2NyZWRzKCkgdXNlci1zcGFjZSBhYnVz
ZQpNSU1FLVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRG
LTgKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKU2lnbmVkLW9mZi1ieTogU2FsdmEg
UGVpcsOzIDxzcGVpcm9mckBnbWFpbC5jb20+Ci0tLQoga2VybmVsL2NyZWQuYyB8IDcgKysrKysr
KwogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9j
cmVkLmMgYi9rZXJuZWwvY3JlZC5jCmluZGV4IDcxMTc5YTAuLjcxOTFkYjMgMTAwNjQ0Ci0tLSBh
L2tlcm5lbC9jcmVkLmMKKysrIGIva2VybmVsL2NyZWQuYwpAQCAtNDI4LDYgKzQyOCwxMyBAQCBp
bnQgY29tbWl0X2NyZWRzKHN0cnVjdCBjcmVkICpuZXcpCiAJICAgICAgIGF0b21pY19yZWFkKCZu
ZXctPnVzYWdlKSwKIAkgICAgICAgcmVhZF9jcmVkX3N1YnNjcmliZXJzKG5ldykpOwogCisJLyog
YmxvY2sgYXR0ZW1wdHMgdG8gdXNlIGNvbW1pdF9jcmVkcyBmcm9tIHVzZXIgc3BhY2UgKi8KKwlp
ZiAoX19idWlsdGluX3JldHVybl9hZGRyZXNzKDApIDwgUEFHRV9PRkZTRVQpIHsKKwkJcHJpbnRr
KEtFUk5fRVJSICJDUkVEOiBCVUcgY29tbWl0X2NyZWRzIGNhbGxlZCBmcm9tIHVzZXItc3BhY2Vc
biIpOworCQlXQVJOX09OKDEpOworCQlyZXR1cm4gLTE7CisJfQorCiAJQlVHX09OKHRhc2stPmNy
ZWQgIT0gb2xkKTsKICNpZmRlZiBDT05GSUdfREVCVUdfQ1JFREVOVElBTFMKIAlCVUdfT04ocmVh
ZF9jcmVkX3N1YnNjcmliZXJzKG9sZCkgPCAyKTsKLS0gCjIuMS40Cgo=
--047d7bb7089e35a5690525659f5b--
