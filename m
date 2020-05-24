Return-Path: <SRS0=RE2q=7G=lists.openwall.com=kernel-hardening-return-18870-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEA4C433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 16:17:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7727020776
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 16:17:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zxw/yjuE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7727020776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18870-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19781 invoked by uid 550); 24 May 2020 16:16:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19744 invoked from network); 24 May 2020 16:16:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590337003;
	bh=5rzhJWqGS7NxsVv+AenK5F0yLsoR3FozPAo0q/n1BlA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Zxw/yjuEnd1TJ34Mmso2+2K+95mZ9xIe13l8Vu7CAlN609PuYXCMGSEG21mTX/Lo1
	 BYVNx00q+409RPowbZmgVVHUJTDFF2KWvSJkuOuEoP/2RXZfoCDs5W7iY0TD6/LOPp
	 o6T2sYn5scy0oil03GuFNkGqL9dhVxd3eTkSDNl4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 24 May 2020 17:16:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
 Jason Cooper <jason@lakedaemon.net>, kernel-hardening@lists.openwall.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/irqchip: Remove function callback casts
In-Reply-To: <20200524160626.GA30346@ubuntu>
References: <20200524080910.13087-1-oscar.carter@gmx.com>
 <20200524124634.113203f6@why> <20200524160626.GA30346@ubuntu>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <b0bd9442c1ba63c38d25ade479885cbd@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oscar.carter@gmx.com, keescook@chromium.org, tglx@linutronix.de, jason@lakedaemon.net, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2020-05-24 17:06, Oscar Carter wrote:
> Hi Marc,
> 
> On Sun, May 24, 2020 at 12:46:34PM +0100, Marc Zyngier wrote:
>> On Sun, 24 May 2020 10:09:10 +0200
>> Oscar Carter <oscar.carter@gmx.com> wrote:
>> 
>> Hi Oscar,
>> 
>> Thanks for this. Comments below.
>> 
>> > In an effort to enable -Wcast-function-type in the top-level Makefile to
>> > support Control Flow Integrity builds, remove all the function callback
>> > casts.
>> >
>> > To do this, modify the IRQCHIP_ACPI_DECLARE macro initializing the
>> > acpi_probe_entry struct directly instead of use the existent macro
>> > ACPI_DECLARE_PROBE_ENTRY.
>> >
>> > In this new initialization use the probe_subtbl field instead of the
>> > probe_table field use in the ACPI_DECLARE_PROBE_ENTRY macro.
>> 
>> Please add *why* this is a valid transformation (probe_table and
>> probe_subtbl are part of a union).
> 
> Ok, I will add a more detailed explanation.
> 
>> > Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
>> > ---
>> >  include/linux/irqchip.h | 10 ++++++++--
>> >  1 file changed, 8 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/include/linux/irqchip.h b/include/linux/irqchip.h
>> > index 950e4b2458f0..1f464fd10df0 100644
>> > --- a/include/linux/irqchip.h
>> > +++ b/include/linux/irqchip.h
>> > @@ -39,8 +39,14 @@
>> >   * @fn: initialization function
>> >   */
>> >  #define IRQCHIP_ACPI_DECLARE(name, subtable, validate, data, fn)	\
>> > -	ACPI_DECLARE_PROBE_ENTRY(irqchip, name, ACPI_SIG_MADT, 		\
>> > -				 subtable, validate, data, fn)
>> > +	static const struct acpi_probe_entry __acpi_probe_##name	\
>> > +		__used __section(__irqchip_acpi_probe_table) = {	\
>> > +			.id = ACPI_SIG_MADT,				\
>> > +			.type = subtable,				\
>> > +			.subtable_valid = validate,			\
>> > +			.probe_subtbl = (acpi_tbl_entry_handler)fn,	\
>> > +			.driver_data = data,				\
>> > +		}
>> >
>> 
>> I'd rather you add an ACPI_DECLARE_SUBTABLE_PROBE_ENTRY to acpi.h, and
>> use that here so that we can keep the ACPI gunk in a single place.
> 
> Ok, I will do the changes you suggested and I will resend a new 
> version.
> Later, I will also send a series to clean up the checkpatch warnings 
> and
> errors for the acpi.h header.

Not necessarily a good idea. Churn for the sake of keeping checkpatch
at bay is pretty pointless. Do fix bugs if you spot any, but please
exercise judgement.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
