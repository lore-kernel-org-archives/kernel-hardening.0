Return-Path: <SRS0=7lLk=FR=lists.openwall.com=kernel-hardening-return-20605-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590D5C433FE
	for <kernel-hardening@archiver.kernel.org>; Sun, 13 Dec 2020 19:05:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 38140239FC
	for <kernel-hardening@archiver.kernel.org>; Sun, 13 Dec 2020 19:05:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38140239FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=mailbox.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20605-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23805 invoked by uid 550); 13 Dec 2020 19:05:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23772 invoked from network); 13 Dec 2020 19:05:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
	in-reply-to:content-disposition:content-type:content-type
	:mime-version:references:message-id:subject:subject:from:from
	:date:date:received; s=mail20150812; t=1607886285; bh=1tFlWouXp8
	P+wOY8Q40bmR8nZ8TrKdBL6VPt94WjMqQ=; b=OwrbvrKN1/SzsVebn5PXuAq+hc
	U+VVfyQIyqvyCVHBBIsQ1sCVk5T6/iun1Re2n14JPViz4AP6bpSeYgAg9AdvfZjq
	nTcPDorRLsZNRaHniUS11YAjGSwxLq3pUGpverYBipOf/kJaPY3mjK7YCUTL/5tw
	EudFqjP/T9fG8HFKykCXdttK/LVlKDxflp3MH38Qx7GnwKz2QrrgPKfC6MDj0a3C
	MLoVDe70UqfBqZ3QkSD0hZmWtgNg1GPCd60F1/xteJCKqUxUoEnGPLEXlqmfpzil
	nP4BMiV5jJnceiZw/LefJ+fQgO2GP9RY0MnvnMj/BnwLnoUIG755fIND4llQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1607886287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1tFlWouXp8P+wOY8Q40bmR8nZ8TrKdBL6VPt94WjMqQ=;
	b=a1xdF9Uz5RT5bBt/tP+1RWHMfIdzZsfFe1SLW3wuLukq0ZtSCsbbKquqK0bkQZlXI6ThJf
	fknY2yLbb/abXpNT/Wr43UDmVg03GH5OW6Cml8puXOlAzFuaDQ12asRYPTcRDg8Lu/H4P2
	2V1y65ZIfnmJTUiyzF197s5AmFW4E/dUSlB9LyWr9u9PF72NTMa2pp08wN8Brt34C9F3zG
	qZXrw8hxAclg9/DoM6M1bV9FNUu0Hd8WGocNqXjfgOO6qe9AghIWyp0GfxcdKVUeMiBIAB
	AvdbstkFbQIlYkAiT7q5zjT8NsSBy3PbFM50G6I1wdDSKR1yqEG2m3//06llww==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Date: Sun, 13 Dec 2020 20:04:42 +0100
From: stefan.bavendiek@mailbox.org
To: Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org
Subject: Re: Kernel complexity
Message-ID: <X9ZlyjtwiKEgOl6p@mailbox.org>
References: <X9UjVOuTgwuQwfFk@mailbox.org>
 <CAG48ez3hO9sEGzxQumSvwkS7PgoEprPJnr6MPzLTwosa+uKzsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ihpLCNs9S0CFscqr"
Content-Disposition: inline
In-Reply-To: <CAG48ez3hO9sEGzxQumSvwkS7PgoEprPJnr6MPzLTwosa+uKzsA@mail.gmail.com>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -7.54 / 15.00 / 15.00
X-Rspamd-Queue-Id: D75F717FC
X-Rspamd-UID: 880b9c


--ihpLCNs9S0CFscqr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thank you for the extensive response.

On Sat, Dec 12, 2020 at 11:34:12PM +0100, Jann Horn wrote:
> On Sat, Dec 12, 2020 at 9:14 PM <stefan.bavendiek@mailbox.org> wrote:
> > Personally I am interested in Linux Kernel Security and especially feat=
ures supporting attack surface reduction. In the past I did some work on sa=
ndboxing features like seccomp support in user space applications. I have b=
een rather hesitant to get involved here, since I am not a full time develo=
per and certainly not an expert in C programming.
>=20
> (By the way, one interesting area where upstream development is
> currently happening that's related to userspace sandboxing is the
> Landlock patchset by Micka=EBl Sala=FCn, which adds an API that allows
> unprivileged processes to restrict their filesystem access without
> having to mess around with stuff like mount namespaces and broker
> processes; the latest version is at
> <https://lore.kernel.org/kernel-hardening/20201209192839.1396820-1-mic@di=
gikod.net/>.
> That might be relevant to your interests.)

That sounds very interesting indeed, thank you.

>=20
> > However I am currently doing a research project that aims to identify r=
isk areas in the kernel by measuring code complexity metrics and assuming t=
his might help this project, I would like to ask for some feedback in case =
this work can actually help with this project.
> >
> > My approach is basically to take a look at the different system calls a=
nd measure the complexity of the code involved in their execution. Since co=
de complexity has already been found to have a strong correlation with the =
probability of existing vulnerabilities, this might indicate kernel areas t=
hat need a closer look.
>=20
> Keep in mind that while system calls are one of the main entry points
> from userspace into the kernel, and the main way in which userspace
> can trigger kernel bugs, syscalls do not necessarily closely
> correspond to specific kernel subsystems.
>=20
> For example, system calls like read() and write() can take a gigantic
> number of execution paths because, especially when you take files in
> /proc and /sys into consideration, they interact with things all over
> the place across the kernel. For example, write() can modify page
> tables of other processes, can trigger page allocation and reclaim,
> can modify networking configuration, can interact with filesystems and
> block devices and networking and user namespace configuration and
> pipes, and so on. But the areas that are reachable through this
> syscall depend on other ways in which the process is limited - in
> particular, what kinds of files it can open.
>=20
> Also keep in mind that even a simple syscall like getresuid() can,
> through the page fault handling code, end up in subsystems related to
> filesystems, block devices, networking, graphics and so on - so you'd
> probably have to exclude any control flows that go through certain
> pieces of core kernel infrastructure.
>=20
> > Additionally the functionality of the syscall will also be considered f=
or a final risk score, although most of the work for this part has already =
been done in [1].
>=20
> That's a paper from 2002 that talks about "UNIX system calls", and
> categorizes syscalls like init_module as being of the highest "threat
> level" even though that syscall does absolutely nothing unless you're
> already root. It also has "denial of service attacks" as the
> second-highest "threat level classification", which I don't think
> makes any sense - I don't think that current OS kernels are designed
> to prevent an attacker with the ability to execute arbitrary syscalls
> from userspace from slowing the system down. Fundamentally it looks to
> me as if it classifies syscalls by the risk caused if you let an
> attacker run arbitrary code in userspace **with root privileges**,
> which seems to me like an extremely silly threat model.
>=20
> > The objective is to create a risk score matrix for linux syscalls that =
consists of the functionality risk according to [1], times the measured com=
plexity.
>=20
> I don't understand why you would multiply functionality risk and
> complexity. They're probably more additive than multiplicative, since
> in a per-subsystem view, risk caused by functionality and complexity
> of the implementation are often completely separate. For example, the
> userfaultfd subsystem introduces functionality risk by allowing
> attackers to arbitrarily pause the kernel at any copy_from_user()
> call, but that doesn't combine with the complexity of the userfaultfd
> subsystem, but with the complexity of all copy_from_user() callers
> everywhere across the kernel.
>=20
> > This will (hopefully) be helpful to identify risk areas in the kernel a=
nd provide user space developers with an measurement that can help design s=
ecure software and sandboxing features.
>=20
> I'm not sure whether this would really be all that helpful for
> userspace sandboxing decisions - as far as I know, userspace normally
> isn't in a position where it can really choose which syscalls it wants
> to use, but instead the choice of syscalls to use is driven by the
> requirements that userspace has. If you tell userspace that write()
> can hit tons of kernel code, it's not like userspace can just stop
> using write(); and if you then also tell userspace that pwrite() can
> also hit a lot of kernel code, that may be misinterpreted as meaning
> that pwrite() adds lots of risk while actually, write() and pwrite()
> reach (almost) the same areas of code. Also, the areas of code that a
> syscall like write() can hit depend hugely on file system access
> policies.

Some issues I have come across revolve around how much attention the
avoidance of certain system calls should get based on the risk.
Many applications e.g. like "file" include a seccomp filter that
restricts most systemcalls from ever being used, without using a broker
architecture. This is feasible for small applications that do not always
need to do dangerous things like execve or open (for write).=20
This decision is however often made without extensive research on what
systemcalls provide dangerous functionality. The idea was to change that
by providing a risk score for systemcalls.


> I also don't think that doing something like this on a per-syscall
> basis would be very beneficial for informing something like priorities
> for auditing kernel code; only a small chunk of the kernel even has
> its own syscalls, while most of it receives commands through
> more-or-less generic syscalls that are then plumbed through.
>=20

Thank you for that explanation. I was afraid something like this might
be the case. I suppose I will change my approach to something more
generic and not focus on system calls for the complexity analysis.
Hopefully this will yeild some helpful results.

> > One major aspect I am still not sure about is the challenges regarding =
the dynamic measure of code path execution. While it is possible to measure=
 the cyclomatic complexity of the kernel code with existing tools, I am not=
 sure how much value the results would have, given that this does not inclu=
de the dynamic code path behind each syscall. I was thinking of using ftrac=
e to follow and measure the execution path. Any feedback and advise on this=
 for this would be appreciated.


--ihpLCNs9S0CFscqr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEjLwAv8xLYF1doyZLdIuckz2DLQMFAl/WZb8ACgkQdIuckz2D
LQPe4w/+I3Nw8z8kGb+7AqxS5Pc4Zuuf+Yxu4v9m6lQkRvrurva4+/d+eUT57ewz
n+euiHAyPIPslHLLkz12qBrI4HAEE/E1lSFMHaJBulVTN00ncL/c5/AgaGkL3Aan
UVxKx8mDgml6cdF8YRJTFk/o/eZYfTIrPqG4rBf9ZQviJO41O7+QqIGdQCHEYyRC
eZT7ogPvauN1FXDCVyYObvqnr7ErY2G7qcwJ2jJeRl1iVhUHsIz8UKauMmTD2jIY
Ps3wzv6tG6Fpg4DbuXx796A03wMLd8Iqw5xBMk7t/wDXEDOkOcmJvLRUSu0EHyen
P+EfpUf60cX1aZron/pUVBQGb71HHtVK1ev5RDgTZ1cN1bkUchfR/ECLRtWdyH7D
rOcZtbubPbMlQ4xsZ+1N2BS/ChrqKdsEV1dsk5xmDF/sUnWo+tAXYe2IMG1giBBq
ZbZyviUsoJDrqvGgsPpSYOHq2ug36XH30m0anE6H87m7qKne0A3Xtv79fBC38DDV
cWjo+bB6IxTLZaoIfGJ+Mj2FeX4Gyl7NpTrcvk6vXgAjAIg5Kek/GbvLrA3iI8uJ
ONliCbYRzDM8/IyOWdY2nYteT6R6oIlf5nGs7qjjK1aj9bY780GLDRyzZbOkxwYy
JU6E4Zvvy3Vtc9RC9/Lx/wLz8gl1YEEGzEpcssmZYaFTl10N2sE=
=Q9en
-----END PGP SIGNATURE-----

--ihpLCNs9S0CFscqr--
