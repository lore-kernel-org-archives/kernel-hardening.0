Return-Path: <SRS0=MKBj=66=lists.openwall.com=kernel-hardening-return-18822-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC94EC433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 16 May 2020 07:25:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0D3902074D
	for <kernel-hardening@archiver.kernel.org>; Sat, 16 May 2020 07:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="J0TPnklq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D3902074D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18822-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30181 invoked by uid 550); 16 May 2020 07:25:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30146 invoked from network); 16 May 2020 07:25:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1589613935;
	bh=pgRQDV9HlwUwXlsemXUtRgXLuCi/uUR6iMJiy3ASUKg=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J0TPnklqRjjZuhzys4zQQZHGkrrqKqCeRDjW12BPLTRVgBSPAzCtPywK94tWOL5MP
	 k43kL2Hz3e5O9Oh8MkwRWYuFGWJfMBAJcavgxxtQkvbSsSU9Bgm4SFL/QGMgozFnrT
	 peP6bhKtNymLn57hXIg6V+sqT9jk6CEN25E83MTo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 16 May 2020 09:25:23 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com,
	Oscar Carter <oscar.carter@gmx.com>
Subject: Re: Get involved in the KSPP
Message-ID: <20200516072522.GA3435@ubuntu>
References: <20200509122007.GA5356@ubuntu>
 <202005110912.3A26AF11@keescook>
 <20200514172037.GA3127@ubuntu>
 <202005150125.8EDF28F00@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005150125.8EDF28F00@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:qzE5WCIaheKeCzT2G+7uwtcEpEscUMOmuTGXFIlFOXW+8Hrry6u
 ACEzmEroT99aoKQiGmOcW48H/H13rvLbGRmw1jYN/9BrFmt1EpXxgusEH5xJjs9usFvbELu
 hQwXitSAq7Ngw9PCAqUixZ1tPqQhYM4700nfyEvImvDKZYWg1qqJFFZVpARnghf9SOMslU4
 NfhFvInh/r1tiCOiDQxFw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:TbKb19k8jxw=:LWFBerYOotVHBnupBAZnzh
 05KvJbejrOVf4WQOT6vHPnebU6d93Nm/R22Fruylk7DF+af4aj0gPF2T0H8MVZSnTtAM8L1wr
 7GHg+Ujc6cZRdvelicJQXTJUq+OmKW2r5757/GkVOR1lFla4OrHPoLjpgQZDqVdBTUbDxxHjE
 VNYtxVOSnBHav6HwjTvG/L2y1li5OApQC81AxQTRK/jnBOAZuKlOk+KWLSDrBip463JtYHkqw
 ufu4WO1lNkL5OnuKtRzjCmlwkRTws1V1rs2DhtuUIKII+4/7LlPUUsrPtJvug+pHTdAVlDWG/
 8FEdB9jKx+rrhabaGkj6bjzQ5gM2Pod98VwxVWl1quv0BiCwTIgtWmvp4TLBeoNhWtB2yc6SV
 LVoM68OBVj4DliArHMGgFfeQT6kKkbJzJGWJV/p36NxkoyStaAW7+nW7pBeoO3WGSbHCorq3M
 9fWq4VuZbPoE7ribojEmUPrJ81O7vGbB2NGNI/kJNPF1PT4Pq0363G4pseCQrcShur9pZIJPm
 2y/wFRCfJLXExDvQc4T4Kf4QjNXTop9keLYJUXyKnABqk7rtIDS9vm7A2lnGu1yXbki9YKip6
 6lQGU6nrzMaLDIv+4i93aCI8Z5QyJcZS+8eT1HmJDiBQ77HM4ZV3vjfJ3rZ9uWOFQCUWBYBKm
 OcpQGmHOMzkKjY7EL0y260Z3t56yZdeJ+T+UGYNDRB9ykC9gSRZeGRSG3cgnLukOMLC4Hn5bj
 QMALBryQvlqKEO3lHlLY4RPmDXM0HdoUub80KuhN0ct6zU49ooE/KuPa5QNmRhrvum8E8r8kI
 oG5n/q2zqQGRTdM4db1yAZmFSGkvDZBWDeVbiZQAHr3f8f7bWOx/n3Zr9qluc92cYe38sBZQA
 MqhkWzvgOgqHOTA2nRU/VAYiXpwR+lWrg6rG5qPNFy2JIj8p9H4XgLPtrZuKt3jn1nw/pT2lX
 slazxdtvTS7E1MdGXSQNIgfcXYYNvXVQ34KRVK4x6gjEQqaLqjX2JuUFxP18V9nD2d3UDbLmH
 siaL5kn6dk8jJgGZylZrSV2Z4sREG8VYJxblGE+BQewuQ1PeRpXvDcTTjq8YKiN0SzwWH75En
 EoLnu3rvpHmpCrhWTyXGJnJZnh2n1olMSxDASS71wf7gfsidvtlUHm5Au3HZFX2RFRlpjYd2Z
 nVmSItwLifOf9C4h25swVXPVvAvhAax6IbmohGqv+agHEoc7cAHToieCBmAiW5S0ac5A7LamU
 W3pJBIPGDOOYvMWip
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 01:27:32AM -0700, Kees Cook wrote:
> On Thu, May 14, 2020 at 07:20:37PM +0200, Oscar Carter wrote:
> > On Mon, May 11, 2020 at 09:15:18AM -0700, Kees Cook wrote:
> > > One mostly mechanical bit of work would be this:
> > > https://github.com/KSPP/linux/issues/20
> > > There are likely more fixes needed to build the kernel with
> > > -Wcast-function-type (especially on non-x86 kernels). So that would =
let
> > > you learn about cross-compiling, etc.
> > >
> > > Let us know what you think!
> >
> > Great. This task seems good to me. I'm already working on it but I wou=
ld like to
> > know if it's correct to compile my work against the master branch of L=
inus tree
> > or if there is some other better branch and tree.
>
> For doing these kinds of things I tend to recommend either the last
> full release from Linus (e.g. v5.6) or, if you want, the latest -rc2
> (e.g. v5.7-rc2). Both are tagged, so you can based your tree on them
> easily:
>
> $ git clone ....
> $ git checkout v5.7-rc2 -b devel/cast-function-type
> $ *do stuff, etc*

Thanks for the clarification.

> --
> Kees Cook

Regards.

Oscar Carter
