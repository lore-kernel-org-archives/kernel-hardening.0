Return-Path: <SRS0=ch6z=4N=lists.openwall.com=kernel-hardening-return-17919-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A06C35E04
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:56:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B56C2084E
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="anCpnV7x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B56C2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17919-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26351 invoked by uid 550); 25 Feb 2020 17:56:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26331 invoked from network); 25 Feb 2020 17:56:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3hs8ic9vVHZ01buQwpJNWy/TUEvM8U2pC7/qWbn+NOM=;
        b=anCpnV7xlItClBNqfKJKEuX0+Ll9aQf2pYeHeWhibo96ELCS4mv/g9IL2Xb7fs3lyr
         j1JDfFE4rGpZL/Ix0EtPr0d4kCD9h8fsgdWl4iLv4nYZBEO6xYJxjIU+Rdv+mceqBjV4
         Yb5g5P3dJJ0HIVFjoVjbYiWCCWKAd4CqQO6jsXShonwl+kMlgNahDe89OP6j5XrPF05c
         j10vzCk7IhnTQNHfIyua1PlwNWWjKeZrPFdOTbTYlpZ9wD4iIcz8slu13oWL7Z8L9AT2
         lhVDbdERuZHoZj/ZH2NwMygGo6nrclUnZ1jAa3EJDcFPLVp9T+Aj99UqE+UBcet/BdXT
         m/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=3hs8ic9vVHZ01buQwpJNWy/TUEvM8U2pC7/qWbn+NOM=;
        b=iwjdIebBdiBoOY78vy3eEU2uLxcIFC7t8LCTjo+AzNr2hXPRLJNhPvOnvxC/tKD0qR
         Z1bdB7x0oNzsCE1Oio5oHhXyciTExQsbNaw8Dc7P1zMymuP8XDFs+6RCzSNI3QCokz2x
         QNSfNQqNS8M5GdQ3bKd5ulIOP+Ifspjd9BEulzJLFIJE5I8ZR7dlnPvpPa0x7Zon+YUT
         WENs+tuOWfk16vv1kIDG6yTMtRqWy0IDdz1CMItFak8XvSx7ckUoFf7xl3mW0nPByR/V
         kmYXKnq3FzzasRXHSQLjq3oxSxu2WqWby5Urja0IoN9v9pMElcTT1Tvrsis8rDzIzAPS
         tA/g==
X-Gm-Message-State: APjAAAWwdlBn4xOJvAGUMh7U8XQXnNIpuSkrfJiLLQJKA3j0iUek9gRC
	HoPib0dQYfp2yz6I1ImV4Y4=
X-Google-Smtp-Source: APXvYqyx9n40miwYyCuyv4aQKn8lvatih3q8mIyyGKRE7NWW9JJufz7abilWeL/R1oQhdKa5VThcGg==
X-Received: by 2002:ae9:e204:: with SMTP id c4mr10263743qkc.429.1582653348476;
        Tue, 25 Feb 2020 09:55:48 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Tue, 25 Feb 2020 12:55:46 -0500
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, keescook@chromium.org,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 05/11] x86: Makefile: Add build and config option for
 CONFIG_FG_KASLR
Message-ID: <20200225175544.GA1385238@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-6-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-6-kristen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 05, 2020 at 02:39:44PM -0800, Kristen Carlson Accardi wrote:
> Allow user to select CONFIG_FG_KASLR if dependencies are met. Change
> the make file to build with -ffunction-sections if CONFIG_FG_KASLR
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  Makefile         |  4 ++++
>  arch/x86/Kconfig | 13 +++++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index c50ef91f6136..41438a921666 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -846,6 +846,10 @@ ifdef CONFIG_LIVEPATCH
>  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
>  endif
>  
> +ifdef CONFIG_FG_KASLR
> +KBUILD_CFLAGS += -ffunction-sections
> +endif
> +

With -ffunction-sections I get a few unreachable code warnings from
objtool.

arch/x86/kernel/dumpstack.o: warning: objtool: show_iret_regs()+0x10: unreachable instruction
fs/sysfs/dir.o: warning: objtool: sysfs_create_mount_point()+0x4f: unreachable instruction
kernel/time/clocksource.o: warning: objtool: __clocksource_register_scale()+0x21: unreachable instruction
drivers/tty/sysrq.o: warning: objtool: sysrq_filter()+0x2ef: unreachable instruction
arch/x86/mm/fault.o: warning: objtool: pgtable_bad()+0x3f: unreachable instruction
drivers/acpi/pci_root.o: warning: objtool: acpi_pci_osc_control_set()+0x123: unreachable instruction
drivers/rtc/class.o: warning: objtool: devm_rtc_device_register()+0x40: unreachable instruction
kernel/power/process.o: warning: objtool: freeze_processes.cold()+0x0: unreachable instruction
drivers/pnp/quirks.o: warning: objtool: quirk_awe32_resources()+0x42: unreachable instruction
drivers/acpi/utils.o: warning: objtool: acpi_evaluate_dsm()+0xf1: unreachable instruction
kernel/reboot.o: warning: objtool: __do_sys_reboot()+0x1b6: unreachable instruction
kernel/power/swap.o: warning: objtool: swsusp_read()+0x185: unreachable instruction
drivers/hid/hid-core.o: warning: objtool: hid_hw_start()+0x38: unreachable instruction
drivers/acpi/battery.o: warning: objtool: sysfs_add_battery.cold()+0x1a: unreachable instruction
arch/x86/kernel/cpu/mce/core.o: warning: objtool: do_machine_check.cold()+0x33: unreachable instruction
drivers/pcmcia/cistpl.o: warning: objtool: pccard_store_cis()+0x4e: unreachable instruction
drivers/gpu/vga/vgaarb.o: warning: objtool: pci_notify()+0x35: unreachable instruction
arch/x86/kernel/tsc.o: warning: objtool: determine_cpu_tsc_frequencies()+0x45: unreachable instruction
drivers/pcmcia/yenta_socket.o: warning: objtool: ti1250_override()+0x50: unreachable instruction
fs/proc/proc_sysctl.o: warning: objtool: sysctl_print_dir.isra.0()+0x19: unreachable instruction
drivers/iommu/intel-iommu.o: warning: objtool: intel_iommu_init()+0x4f4: unreachable instruction
net/mac80211/ibss.o: warning: objtool: ieee80211_ibss_work.cold()+0x157: unreachable instruction
drivers/net/ethernet/intel/e1000/e1000_main.o: warning: objtool: e1000_clean.cold()+0x0: unreachable instruction
net/core/skbuff.o: warning: objtool: skb_dump.cold()+0x3fd: unreachable instruction
