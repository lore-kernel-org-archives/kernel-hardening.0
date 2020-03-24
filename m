Return-Path: <SRS0=s4B7=5J=lists.openwall.com=kernel-hardening-return-18211-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD9AC10DCE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:25:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 853722076F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 853722076F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18211-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28423 invoked by uid 550); 24 Mar 2020 21:25:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28398 invoked from network); 24 Mar 2020 21:25:23 -0000
IronPort-SDR: LXuNVZpXjgVPq5LR3RC/tPWAKjSkRf/6cflzUkuOR1YtyDvyL5rhk89POxzzv7NGGWTg4O2Obo
 w4xxw/7WTerA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: mN5mW36bByfx8u23caSwnMSwzlVG0gkUNRt7tD/10fEzNJJZ2RY/DgvZQ40y7vKwPOVR487G31
 vY7WdAYs8ORA==
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="265298598"
Message-ID: <a01e6b2f0a19f0ace0b5f2c8a50cafccc9b4ef60.camel@linux.intel.com>
Subject: Re: [RFC PATCH 05/11] x86: Makefile: Add build and config option
 for CONFIG_FG_KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	arjan@linux.intel.com, keescook@chromium.org, rick.p.edgecombe@intel.com, 
	x86@kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Tue, 24 Mar 2020 14:24:51 -0700
In-Reply-To: <20200225175544.GA1385238@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-6-kristen@linux.intel.com>
	 <20200225175544.GA1385238@rani.riverdale.lan>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2020-02-25 at 12:55 -0500, Arvind Sankar wrote:
> On Wed, Feb 05, 2020 at 02:39:44PM -0800, Kristen Carlson Accardi
> wrote:
> > Allow user to select CONFIG_FG_KASLR if dependencies are met.
> > Change
> > the make file to build with -ffunction-sections if CONFIG_FG_KASLR
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > ---
> >  Makefile         |  4 ++++
> >  arch/x86/Kconfig | 13 +++++++++++++
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/Makefile b/Makefile
> > index c50ef91f6136..41438a921666 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -846,6 +846,10 @@ ifdef CONFIG_LIVEPATCH
> >  KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
> >  endif
> >  
> > +ifdef CONFIG_FG_KASLR
> > +KBUILD_CFLAGS += -ffunction-sections
> > +endif
> > +
> 
> With -ffunction-sections I get a few unreachable code warnings from
> objtool.
> 
> arch/x86/kernel/dumpstack.o: warning: objtool: show_iret_regs()+0x10:
> unreachable instruction
> fs/sysfs/dir.o: warning: objtool: sysfs_create_mount_point()+0x4f:
> unreachable instruction
> kernel/time/clocksource.o: warning: objtool:
> __clocksource_register_scale()+0x21: unreachable instruction
> drivers/tty/sysrq.o: warning: objtool: sysrq_filter()+0x2ef:
> unreachable instruction
> arch/x86/mm/fault.o: warning: objtool: pgtable_bad()+0x3f:
> unreachable instruction
> drivers/acpi/pci_root.o: warning: objtool:
> acpi_pci_osc_control_set()+0x123: unreachable instruction
> drivers/rtc/class.o: warning: objtool:
> devm_rtc_device_register()+0x40: unreachable instruction
> kernel/power/process.o: warning: objtool:
> freeze_processes.cold()+0x0: unreachable instruction
> drivers/pnp/quirks.o: warning: objtool: quirk_awe32_resources()+0x42:
> unreachable instruction
> drivers/acpi/utils.o: warning: objtool: acpi_evaluate_dsm()+0xf1:
> unreachable instruction
> kernel/reboot.o: warning: objtool: __do_sys_reboot()+0x1b6:
> unreachable instruction
> kernel/power/swap.o: warning: objtool: swsusp_read()+0x185:
> unreachable instruction
> drivers/hid/hid-core.o: warning: objtool: hid_hw_start()+0x38:
> unreachable instruction
> drivers/acpi/battery.o: warning: objtool:
> sysfs_add_battery.cold()+0x1a: unreachable instruction
> arch/x86/kernel/cpu/mce/core.o: warning: objtool:
> do_machine_check.cold()+0x33: unreachable instruction
> drivers/pcmcia/cistpl.o: warning: objtool: pccard_store_cis()+0x4e:
> unreachable instruction
> drivers/gpu/vga/vgaarb.o: warning: objtool: pci_notify()+0x35:
> unreachable instruction
> arch/x86/kernel/tsc.o: warning: objtool:
> determine_cpu_tsc_frequencies()+0x45: unreachable instruction
> drivers/pcmcia/yenta_socket.o: warning: objtool:
> ti1250_override()+0x50: unreachable instruction
> fs/proc/proc_sysctl.o: warning: objtool:
> sysctl_print_dir.isra.0()+0x19: unreachable instruction
> drivers/iommu/intel-iommu.o: warning: objtool:
> intel_iommu_init()+0x4f4: unreachable instruction
> net/mac80211/ibss.o: warning: objtool:
> ieee80211_ibss_work.cold()+0x157: unreachable instruction
> drivers/net/ethernet/intel/e1000/e1000_main.o: warning: objtool:
> e1000_clean.cold()+0x0: unreachable instruction
> net/core/skbuff.o: warning: objtool: skb_dump.cold()+0x3fd:
> unreachable instruction

I'm still working on a solution, but the issue here is that any .cold
function is going to be in a different section than the related
function, and when objtool is searching for instructions in
find_insn(), it assumes that it must be in the same section as the
caller.

