Return-Path: <SRS0=JAPA=7M=lists.openwall.com=kernel-hardening-return-18897-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83040C433E0
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 09:35:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BF2612074A
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 09:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="afSN9k+P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF2612074A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18897-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31786 invoked by uid 550); 30 May 2020 09:35:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31751 invoked from network); 30 May 2020 09:35:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590831294;
	bh=cnzA5tk70oUMN1xavPXuXqS1gyDfBDfKfmW9R6LENeU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=afSN9k+Pnz25M3k6V81ZfUhf+aa07mHbRs0ZOwQNgydwOI0qbGo+BG19nTp60pXxE
	 RoU9Uyf0O90HOI4P6/L+Q/O88mjI2amYWp2qK5fo1AzcK/qRZkIQIpnDR2yN20caIB
	 siiIVmR0CUTFH+Edx5VfoUxCArkPhJepzSJ0OfJM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 30 May 2020 10:34:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
 Jason Cooper <jason@lakedaemon.net>, "Rafael J. Wysocki"
 <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
 kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 2/2] drivers/irqchip: Use new macro
 ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
In-Reply-To: <20200529171847.10267-3-oscar.carter@gmx.com>
References: <20200529171847.10267-1-oscar.carter@gmx.com>
 <20200529171847.10267-3-oscar.carter@gmx.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <590725ccfadc6e6c84c777f69ee02a62@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oscar.carter@gmx.com, keescook@chromium.org, tglx@linutronix.de, jason@lakedaemon.net, rjw@rjwysocki.net, lenb@kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hi Oscar,

On 2020-05-29 18:18, Oscar Carter wrote:
> In an effort to enable -Wcast-function-type in the top-level Makefile 
> to
> support Control Flow Integrity builds, there are the need to remove all
> the function callback casts.
> 
> To do this, modify the IRQCHIP_ACPI_DECLARE macro to use the new 
> defined
> macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY instead of the macro
> ACPI_DECLARE_PROBE_ENTRY. This is necessary to be able to initialize 
> the
> the acpi_probe_entry struct using the probe_subtbl field instead of the
> probe_table field and avoid function cast mismatches.
> 
> Also, modify the prototype of the functions used by the invocation of 
> the
> IRQCHIP_ACPI_DECLARE macro to match all the parameters.
> 
> Co-developed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
> ---
>  drivers/irqchip/irq-gic-v3.c | 2 +-
>  drivers/irqchip/irq-gic.c    | 2 +-
>  include/linux/irqchip.h      | 5 +++--
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3.c 
> b/drivers/irqchip/irq-gic-v3.c
> index d7006ef18a0d..3870e9d4d3a8 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -2117,7 +2117,7 @@ static void __init gic_acpi_setup_kvm_info(void)
>  }
> 
>  static int __init
> -gic_acpi_init(struct acpi_subtable_header *header, const unsigned long 
> end)
> +gic_acpi_init(union acpi_subtable_headers *header, const unsigned long 
> end)
>  {
>  	struct acpi_madt_generic_distributor *dist;
>  	struct fwnode_handle *domain_handle;
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 30ab623343d3..fc431857ce90 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -1593,7 +1593,7 @@ static void __init gic_acpi_setup_kvm_info(void)
>  	gic_set_kvm_info(&gic_v2_kvm_info);
>  }
> 
> -static int __init gic_v2_acpi_init(struct acpi_subtable_header 
> *header,
> +static int __init gic_v2_acpi_init(union acpi_subtable_headers 
> *header,
>  				   const unsigned long end)
>  {
>  	struct acpi_madt_generic_distributor *dist;
> diff --git a/include/linux/irqchip.h b/include/linux/irqchip.h
> index 950e4b2458f0..447f22880a69 100644
> --- a/include/linux/irqchip.h
> +++ b/include647b532275bbe/linux/irqchip.h
> @@ -39,8 +39,9 @@
>   * @fn: initialization function
>   */
>  #define IRQCHIP_ACPI_DECLARE(name, subtable, validate, data, fn)	\
> -	ACPI_DECLARE_PROBE_ENTRY(irqchip, name, ACPI_SIG_MADT, 		\
> -				 subtable, validate, data, fn)
> +	ACPI_DECLARE_SUBTABLE_PROBE_ENTRY(irqchip, name,		\
> +					  ACPI_SIG_MADT, subtable,	\
> +					  validate, data, fn)
> 
>  #ifdef CONFIG_IRQCHIP
>  void irqchip_init(void);
> --
> 2.20.1

I can't help but notice that you have left the cast in 
ACPI_DECLARE_PROBE_ENTRY, which should definitely go. Probably worth a 
third patch.

Thanks,

         M.

-- 
Jazz is not dead. It just smells funny...
