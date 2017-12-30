MIME-Version: 1.0
In-Reply-To: <20171230175804.7354-6-alonid@gmail.com>
References: <20171230175804.7354-1-alonid@gmail.com> <20171230175804.7354-6-alonid@gmail.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Sat, 30 Dec 2017 14:14:43 -0500
Message-ID: <CAFUG7Ce8tA5c=2Er2hOHrgAWjMcSNMqh9CLVg4UzHG=k-PuqZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [PATCH 5/5] docs: add dmesg encryption doc
To: Dan Aloni <dan@kernelim.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Dec 30, 2017 at 12:58 PM, Dan Aloni <dan@kernelim.com> wrote:
> From: Dan Aloni <dan@kernelim.com>
>
> Signed-off-by: Dan Aloni <dan@kernelim.com>
> ---
>  Documentation/admin-guide/dmesg-encryption.rst | 77 ++++++++++++++++++++=
++++++
>  1 file changed, 77 insertions(+)
>  create mode 100644 Documentation/admin-guide/dmesg-encryption.rst
>
> diff --git a/Documentation/admin-guide/dmesg-encryption.rst b/Documentati=
on/admin-guide/dmesg-encryption.rst
> new file mode 100644
> index 000000000000..4a3d087b7f98
> --- /dev/null
> +++ b/Documentation/admin-guide/dmesg-encryption.rst
> @@ -0,0 +1,77 @@
> +Kernel message encryption
> +-------------------------
> +
> +.. CONTENTS
> +..
> +.. - Overview
> +.. - Reason for encrypting dmesg
> +.. - Compile time and run time switches
> +.. - Limitations
> +.. - Decrypting dmesg
> +
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Similaly the module signing facility, it is also possible to have the ke=
rnel perform public key encryption of the kernel messages that are being ge=
nerated by printk calls.
> +
> +The encryption can be performed for one of the trusted public keys in th=
e kernel keyring, and by default will be performed against the kernel's mod=
uel signing key.

Typo - s/moduel/module/

> +
> +To prevent a run-time dependency inside printk itself, the encryption ta=
kes places upon trying to read ``/dev/kmsg`` which is the mechanism currenl=
y used by ``systemd`` to read kernel messages, and is also used by ``dmesg`=
` invocations.

Typo - s/currenly/currently/

> +
> +The first line being read by a ``dmesg`` opener will be an artificial li=
ne containing an encrypted symmetric encryption session key, in RSA PKCS#1 =
format. The other lines are messages encrypted under an AES-128-GCM scheme.=
 All binary ciphertext is hex-encoded, so that the ciphertext solely compri=
ses of printable characters.
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Limitations
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +There are various limitations one need to consider when enabling dmesg e=
ncryption:
> +
> +  * The metadata of kernel messages is not part of the encryption (times=
tamp, log facility, log severity).
> +  * The seldom accompanying dictionary is also not part of the encryptio=
n.
> +  * Any output to any system console, happening when printk() itself is =
executing, is also not encrypted. A potential attacker can load up ``netcon=
sole`` and have kernel messages being sent as plaintext to other machines. =
Hopefully, on embedded devices, all system consoles are under strict contro=
l of the developers.
> +  * The syslog system call is barred from reading kmsg. Its present user=
s are few, as the system call's interface is mostly a fallback to an inacce=
ssible ``/dev/kmsg``. This is only an implementation limitation and that ma=
y be addressed.
> +  * kmsg buffers will still be saved as plaintext inside kdumps. The ass=
umption is that having an access to read a kdump is equivalent to full kern=
el access anyway.
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +Reason for encryption dmesg
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +
> +For years, dmesg has contained data which could be utilized by vulnerabi=
lity exploiters, allowing for privilege escalations. Developers may leave k=
ey data such as pointers, indication of driver bugs, and more.
> +
> +The feature is mostly aimed for device manufacturers who are not keen on=
 revealing the full details of kernel execution, bugs, and crashes to their=
 users, but only to their developers, so that local programs running on the=
 devices cannot use the data for 'rooting' and executing exploits.
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Compile time and run time switches
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +In build time, this feature is controlled via the ``CONFIG_KMSG_ENCRYPTI=
ON`` configuration variable.
> +
> +In run time, it can be turned off by providing `kmsg.encrypt=3D0` as a b=
oot time parameter.
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Decrypting dmesg
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +A supplied program in the kernel tree named ``dmesg-decipher``, uses the=
 OpenSSL library along with the paired private key of the encryption, in or=
der to decipher an encrypted dmesg.
> +
> +An innocuous dmesg invocation will appear as such (with the ciphertexts =
shortened here for the brevity of this document)::
> +
> +    [    0.000000] K:7c7da3617b6f...f4098e2425af00
> +    [    0.000000] M:36ae318532e...61686821b3ab,16,12
> +    [    0.000000] M:7fca10...154e035,16,12
> +    ....
> +
> +The artificial ``K:`` message is generated per opening of ``/dev/kmsg``.=
 It contains the encrypted session key. The encrypted dmesg lines follows i=
t (prefix ``M:``).
> +
> +Provided with the private key, deciphering a dmesg output should be a st=
raight-forward process.
> +
> +For example, one can save an encrypted dmesg to ``dmesg.enc`` in one mac=
hine, then transfer it to another machine which contains access to the PEM =
with the decrypting private key, and use the the following command::
> +
> +    cat dmesg.enc | ./tools/kmsg/dmesg-decipher certs/signing_key.pem
> +
> +    [    0.000000] Linux version 4.15.0-rc5+ (dan@jupiter) (gcc version =
7.2.1 20170915 (Red Hat 7.2.1-2) (GCC)) #109 SMP Sat Dec 30 18:32:25 IST 20=
17
> +    [    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-4.15.0-rc5-dan+ r=
oot=3DUUID=3Df48b37ec-fcb8-4689-b12e-58703db3cb21 ro rhgb quiet LANG=3Den_U=
S.UTF-8
> +    [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floatin=
g point registers'
> +    ...
> --
> 2.13.6
>

The proposed use case for embedded developers and other constrained
systems makes me wonder how useful a GPL-only facility is in those
situations. AFAIK the Linux crypto subsystem is pretty restrictive for
non-GPL modules (Tom Caputi of Datto had to port over a ton of Illumos
crypto code for ZFS), and third-party components which can't be
released under GPL also shouldn't be linking against GPL-only
functions. I'm woefully unfamiliar with the history and context around
decisions to mark things GPL-only, so please pardon my ignorance on
the matter, but in practice this might be a barrier to legal
real-world use.

Another use case for this, by the way, is for private clouds where
instance owners may be untrusted and the hypervisor or cloud fabric
have access to the decryption keys as well as out-of-band dmesg
outputs since they hook ttySX in the VM and spool to a buffer outside
the instance. Bugs in virtual devices mapping physical memory would
produce usable output for the cloud provider to track and tackle,
while increasing the barriers toward mapping host resources from
inside the instance. Obviously an attacker with root access can bypass
this facility with a reboot or kernel replacement, but it does raise
the barrier and forces them to leave footprints like an elephant.
Clouds running containers as the isolation mechanism and sharing a
kernel benefit all the more by reducing cross-container leakage, and
without the kernel concern (if they're escaping the container to alter
that, we're long past this problem domain). Lastly, private instances
in public clouds should also benefit from this as the same semantic
around dumping dmesg to an externally facing serial tty is standard
fare, and the provider can currently see tons of (ideally) privileged
data.

--=20
Boris Lukashev
Systems Architect
Semper Victus
