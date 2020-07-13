Return-Path: <SRS0=C9jg=AY=lists.openwall.com=kernel-hardening-return-19294-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E803CC433EA
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 11:22:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 488272072D
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 11:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rq8Rk1Kv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 488272072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19294-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20433 invoked by uid 550); 13 Jul 2020 11:22:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13850 invoked from network); 13 Jul 2020 09:24:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1594632283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8taBpeNWfYvGCIuu+3RcwP8mgr+DtPBfUd45yt6a9tM=;
	b=Rq8Rk1KvIVnuE9eYYjiOeQ8iU3fgbPSFk90s3TDWA9aFuTBE8OBVmFP+MhQcogqy2KPiIp
	n4B1bUjXZ/e6csGYxU3jBi/I6JnRvkXBEIq/Ue/FjoC8HwdZhAuO/Mow+MXbqhBQsv6+p+
	OchEItMGSsA09QWziXFLwaqw098zjqA=
X-MC-Unique: p6tDz3eYNamNtlQUM20UWg-1
Date: Mon, 13 Jul 2020 10:24:35 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sargun Dhillon <sargun@sargun.me>,
	Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jeff Moyer <jmoyer@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH RFC 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200713092435.GC28639@stefanha-x1.localdomain>
References: <20200710141945.129329-1-sgarzare@redhat.com>
 <20200710153309.GA4699@char.us.oracle.com>
 <20200710162017.qdu34ermtxh3rfgl@steredhat>
MIME-Version: 1.0
In-Reply-To: <20200710162017.qdu34ermtxh3rfgl@steredhat>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline

--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2020 at 06:20:17PM +0200, Stefano Garzarella wrote:
> On Fri, Jul 10, 2020 at 11:33:09AM -0400, Konrad Rzeszutek Wilk wrote:
> > .snip..
> > > Just to recap the proposal, the idea is to add some restrictions to t=
he
> > > operations (sqe, register, fixed file) to safely allow untrusted appl=
ications
> > > or guests to use io_uring queues.
> >=20
> > Hi!
> >=20
> > This is neat and quite cool - but one thing that keeps nagging me is
> > what how much overhead does this cut from the existing setup when you u=
se
> > virtio (with guests obviously)?
>=20
> I need to do more tests, but the preliminary results that I reported on
> the original proposal [1] show an overhead of ~ 4.17 uS (with iodepth=3D1=
)
> when I'm using virtio ring processed in a dedicated iothread:
>=20
>   - 73 kIOPS using virtio-blk + QEMU iothread + io_uring backend
>   - 104 kIOPS using io_uring passthrough
>=20
> >                                 That is from a high level view the
> > beaty of io_uring being passed in the guest is you don't have the
> > virtio ring -> io_uring processing, right?
>=20
> Right, and potentially we can share the io_uring queues directly to the
> guest userspace applications, cutting down the cost of Linux block
> layer in the guest.

Another factor is that the guest submits requests directly to the host
kernel sqpoll thread. When a virtqueue is used the sqpoll thread cannot
poll it directly so another host thread (QEMU) needs to poll the
virtqueue. The same applies for the completion code path.

Stefan

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8MKFMACgkQnKSrs4Gr
c8iWaQgAkvf4Ga+PHPaSTucaASbYCgeYbSgiUPCLRsOB0g2+3HM6buSTHpdfYoUk
Fy1Y3Yl7cDqGmCCHdTx9rYTQCd6SYSElqylNNnn6yEMiMgvcYcK4xn+wgY8BxVGy
yIv0Rl52ucmtkQ4Iry5mA/vSNZiiVnDyP5Mq9EahEKDO9RtC0duf4xJeR1Lhyk9G
QDbDx9I2/TZgsxar1+Tettaf6vbC1d8S5WCSSktvMl7Jn2zP/uyJg9DyuMCRWMVl
YPX8SPGK/Kr0uKRWkWtBdbK0TuDJtM5i8hdD59ppdQaSwt7JrmowOFDKg9iznl4r
Z9f95iJ6QD2dHTtGo4Yc5WKyhZ9BmA==
=KoLY
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--

