Return-Path: <SRS0=2f9T=7G=lists.openwall.com=kernel-hardening-return-18869-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4916C433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 16:06:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 13D4D206D5
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 16:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="CdXI2jfw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13D4D206D5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18869-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11979 invoked by uid 550); 24 May 2020 16:06:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11947 invoked from network); 24 May 2020 16:06:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590336398;
	bh=+nFXZkgBoRhnqmTS84jk7w6behECRnCIt5FlWN27unw=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CdXI2jfwxkxHhkjYgEZDKBvLOInjJrIbNkTKhgpf9K51CAhgoBkwcEjwoit4E3SEA
	 qYnPC8odvgHGPTBHYqe8ayYulpNZvBuXH0LzZ3TB9mK++veVJ9tngwqKKCk2D4xBvr
	 FT3PkQA8DEm457CugrV4LQhgUpxkm1RYx38wACkA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sun, 24 May 2020 18:06:26 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jason Cooper <jason@lakedaemon.net>,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/irqchip: Remove function callback casts
Message-ID: <20200524160626.GA30346@ubuntu>
References: <20200524080910.13087-1-oscar.carter@gmx.com>
 <20200524124634.113203f6@why>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524124634.113203f6@why>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:Rq3XbNZH4RgeTsRXWMEwPYjA3ioEEfsOiDigB7WhoZAsaaG0ZOu
 A9vTfGTRB8dbo96G6XNMN8kjNxfS739adOZlT3CZnIcCDasr1No/RJno1ctMLqodUVP1Bgk
 SgFVFy05cn/+NpRhj5PefHdt2Bqj7RYoNJiyw8LU8LYhicbq7/Vkndafu+HwdguQkL9R4Iw
 Fl1vzIb5IxWltG6cC69KA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ms6icXGKjqo=:aAJKyt7ZHWgYEjxcsva6bg
 TfGGDta8SylgAZlC0e8Fm5yeggoLM5ycxrzGDYbdY935is+0uwCG2J7tTOJB1gRhUIgKQTpvX
 IMZ+NEINwayiDLuOOyOjGs0qwNdMN3l2MYQ3lUstgJfwLxk7vv70ix6uZI5PpwSQqS70o0Xhr
 cofEv7HLyLwbkit9LHcQqE9tvK/mAitODAgaZP7lyahyYTE199ny5RcvoSVpyGiZWXAuWFER1
 ucMWbN0XZiDQPuND4xrjmX0fOpe8MFzDpEOL0oYN47cGtdy8JzV5AUMKlGZUXO0o9pV1XF0Sm
 K7eqPRvt83gEFU7efYssBIfYAng3XA6fX1/Kc9G1Mxi9PxohX7LDskYL8WpB2avUTH0d8TdbT
 XOPsfhO46FqL9/1ip0PwgxVGYt1EZt1+xitrqRWWcCyg1lDkupmQz3hGX8f/zYOWUEc6aniAe
 tfTAqL8Y1kCldbuWNS58yjFXSrZo/LUhWbTIP7VdxC6ixk1R1n7Lg332zuNus6Qh7PZK+xfy1
 6aRbzgQm2KLRxIs0E82qQP3KOsl+CXp8gr17mM2mX3xq339528I+z6JxzvW4I+tpjSx6x6IYX
 iicsKKZXW372r/J8zWN4lI9y+thcWCGTyCHfNVkDhJAbyoFjxfimHw/MzAgh0XqIpAQe5TWIR
 T5a6PjT3A4+nw5F7PxXgDbDo4NssG7OzM9CNtEGH7W8Vcts5JB33tZCW1jqw/eUEpKFU+jtQA
 Nc8M1uG3coH8Xw0/tlC3YNNkL4Hfq60or54Vzqlu+cXjCG3VhUiEZJpMGRq69zqy12mOHxsfQ
 rNP3jht0YH3I9/K3HJjrzmsITBLVibjzGipbZx3FQ6ZaMqI55PqVeGiiiXMQurF9n4fUMteWa
 URnaNDxdO5oAvzYOfCRGXZ9mHtjYPMkNxsqHkSnLa6PgXImSffKkYl7vHGQPOLS8cRWRkGwbV
 pCi+eQ0Kus03a4RaDmDNAjGIqJ36VhZuxUbEKtYdjiRaRSCPwSE3bEz2em6cXEuWMH7Zc1Afs
 GiBggc6JLNZrhHbYUx5aid5e/1maq8WfREz6VTeU2OcQhB0R0xp42xqH18f5DSuGogOqcKb3W
 Ejq6ptOajNhOXzywYNb5twLeNG5WmNSa01J7f5R4OkblHIEZpS63caeAKwa96ewKNzbN2hJO8
 +dG9rj19LOUREcxThLRexH9O5qfvgWtm5SFPvvPp1HKXxfi26npXUgO6ybWe25zjZsNE9Y6p3
 R4DopH9eWK6ZDTrSG
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Sun, May 24, 2020 at 12:46:34PM +0100, Marc Zyngier wrote:
> On Sun, 24 May 2020 10:09:10 +0200
> Oscar Carter <oscar.carter@gmx.com> wrote:
>
> Hi Oscar,
>
> Thanks for this. Comments below.
>
> > In an effort to enable -Wcast-function-type in the top-level Makefile =
to
> > support Control Flow Integrity builds, remove all the function callbac=
k
> > casts.
> >
> > To do this, modify the IRQCHIP_ACPI_DECLARE macro initializing the
> > acpi_probe_entry struct directly instead of use the existent macro
> > ACPI_DECLARE_PROBE_ENTRY.
> >
> > In this new initialization use the probe_subtbl field instead of the
> > probe_table field use in the ACPI_DECLARE_PROBE_ENTRY macro.
>
> Please add *why* this is a valid transformation (probe_table and
> probe_subtbl are part of a union).

Ok, I will add a more detailed explanation.

> > Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
> > ---
> >  include/linux/irqchip.h | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/irqchip.h b/include/linux/irqchip.h
> > index 950e4b2458f0..1f464fd10df0 100644
> > --- a/include/linux/irqchip.h
> > +++ b/include/linux/irqchip.h
> > @@ -39,8 +39,14 @@
> >   * @fn: initialization function
> >   */
> >  #define IRQCHIP_ACPI_DECLARE(name, subtable, validate, data, fn)	\
> > -	ACPI_DECLARE_PROBE_ENTRY(irqchip, name, ACPI_SIG_MADT, 		\
> > -				 subtable, validate, data, fn)
> > +	static const struct acpi_probe_entry __acpi_probe_##name	\
> > +		__used __section(__irqchip_acpi_probe_table) =3D {	\
> > +			.id =3D ACPI_SIG_MADT,				\
> > +			.type =3D subtable,				\
> > +			.subtable_valid =3D validate,			\
> > +			.probe_subtbl =3D (acpi_tbl_entry_handler)fn,	\
> > +			.driver_data =3D data,				\
> > +		}
> >
>
> I'd rather you add an ACPI_DECLARE_SUBTABLE_PROBE_ENTRY to acpi.h, and
> use that here so that we can keep the ACPI gunk in a single place.

Ok, I will do the changes you suggested and I will resend a new version.
Later, I will also send a series to clean up the checkpatch warnings and
errors for the acpi.h header.

> >  #ifdef CONFIG_IRQCHIP
> >  void irqchip_init(void);
> > --
> > 2.20.1
> >
> >
>
> Thanks,
>
> 	M.
> --
> Jazz is not dead. It just smells funny...

Thanks,
Oscar Carter
