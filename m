Return-Path: <kernel-hardening-return-21609-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B7969C61D97
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Jan 2023 14:31:58 +0000 (UTC)
Received: (qmail 5291 invoked by uid 550); 26 Jan 2023 14:31:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5286 invoked from network); 26 Jan 2023 13:58:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674741489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f0NzERiZZJGCAkZaTLp1domqOWjoThIpg30kpPJKWMo=;
	b=LgPZr0CWcD69Ib7kO4JDhNCtFXhcM6VS4dLjXOpc/v570rL57PTj8JqDSM2lR6Y9EWphLS
	Kra91ZN1gfQkBRKEToSPuNEL6iZfqcpjMguXKuLUYX8xkCPwZNWyKaZzkKJYBAb4uDq4Do
	Hv14Dq3dD397LS7AeiPz6oindRJ/tow=
X-MC-Unique: NkbnLCaaOGGZtkinCBTQuA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f0NzERiZZJGCAkZaTLp1domqOWjoThIpg30kpPJKWMo=;
        b=rGEeLqzSNRmZncNoaQgWtVE59NfXNASIG01+121w74aIPWARM49lf13o/hqNkKhOHW
         YhEPy7SUyhRsXB8tk2ofqDpzVuCJNl4U6imzg92Rczr9KJyJDIT3WbmfoP+n2KIOht/L
         ak3A0kJi0AiZjVVHvsJyBYCKsApd2n7AVvPWK1hInyCXzBczwvgolzh6GV++n1qQXFQX
         lb4dtukUrUcQdtFfuxB6ucUWv+uC26vEwv03kCFK6m/sHzpnQQR1zNES1KbXS0fNSR4g
         4xxPcxMRAjU5C10EeTrWIk6aUnKV5kP/FIqyuVEWSCu6Z+eSzEHKWF+XVwRVi3Bm8Gbj
         I/8g==
X-Gm-Message-State: AFqh2kr7hT0chh/r1O1wY1C8hqLeh5nrGTFbrYSrAyDlOpCvDkd05QnG
	9rJ+6A+0vNuSa8wG9ZtOH9JFRZQg0+KuBnEchuW/BTUrvSBQLic6hGdzgQv17YUIYKM67732p3N
	YGO+zY+id8ZNW65EWWqfqHn7bo2NZPkRyCw==
X-Received: by 2002:a05:6000:1b83:b0:2be:34f5:ac05 with SMTP id r3-20020a0560001b8300b002be34f5ac05mr25116507wru.0.1674741485531;
        Thu, 26 Jan 2023 05:58:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtlfKk39QIucgkeq56V++rcPtefVDWtus3l9sNA/xIhsBFjF2sEE7lcJeosUhyIVDqk2W2mNg==
X-Received: by 2002:a05:6000:1b83:b0:2be:34f5:ac05 with SMTP id r3-20020a0560001b8300b002be34f5ac05mr25116492wru.0.1674741485326;
        Thu, 26 Jan 2023 05:58:05 -0800 (PST)
Date: Thu, 26 Jan 2023 13:58:02 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Shishkin, Alexander" <alexander.shishkin@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Kuppuswamy, Sathyanarayanan" <sathyanarayanan.kuppuswamy@intel.com>,
	"Kleen, Andi" <andi.kleen@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Wunner, Lukas" <lukas.wunner@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Poimboe, Josh" <jpoimboe@redhat.com>,
	"aarcange@redhat.com" <aarcange@redhat.com>,
	Cfir Cohen <cfir@google.com>, Marc Orr <marcorr@google.com>,
	"jbachmann@google.com" <jbachmann@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"keescook@chromium.org" <keescook@chromium.org>,
	James Morris <jmorris@namei.org>,
	Michael Kelley <mikelley@microsoft.com>,
	"Lange, Jon" <jlange@microsoft.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Linux guest kernel threat model for Confidential Computing
Message-ID: <Y9KG6g0CHlnKwuW+@work-vm>
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9Jh2x9XJE1KEUg6@unreal>
 <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

* Reshetova, Elena (elena.reshetova@intel.com) wrote:
> > On Wed, Jan 25, 2023 at 03:29:07PM +0000, Reshetova, Elena wrote:
> > > Replying only to the not-so-far addressed points.
> > >
> > > > On Wed, Jan 25, 2023 at 12:28:13PM +0000, Reshetova, Elena wrote:
> > > > > Hi Greg,
> > 
> > <...>
> > 
> > > > > 3) All the tools are open-source and everyone can start using them right
> > away
> > > > even
> > > > > without any special HW (readme has description of what is needed).
> > > > > Tools and documentation is here:
> > > > > https://github.com/intel/ccc-linux-guest-hardening
> > > >
> > > > Again, as our documentation states, when you submit patches based on
> > > > these tools, you HAVE TO document that.  Otherwise we think you all are
> > > > crazy and will get your patches rejected.  You all know this, why ignore
> > > > it?
> > >
> > > Sorry, I didn’t know that for every bug that is found in linux kernel when
> > > we are submitting a fix that we have to list the way how it has been found.
> > > We will fix this in the future submissions, but some bugs we have are found by
> > > plain code audit, so 'human' is the tool.
> > 
> > My problem with that statement is that by applying different threat
> > model you "invent" bugs which didn't exist in a first place.
> > 
> > For example, in this [1] latest submission, authors labeled correct
> > behaviour as "bug".
> > 
> > [1] https://lore.kernel.org/all/20230119170633.40944-1-
> > alexander.shishkin@linux.intel.com/
> 
> Hm.. Does everyone think that when kernel dies with unhandled page fault 
> (such as in that case) or detection of a KASAN out of bounds violation (as it is in some
> other cases we already have fixes or investigating) it represents a correct behavior even if
> you expect that all your pci HW devices are trusted? What about an error in two 
> consequent pci reads? What about just some failure that results in erroneous input? 

I'm not sure you'll get general agreement on those answers for all
devices and situations; I think for most devices for non-CoCo
situations, then people are generally OK with a misbehaving PCI device
causing a kernel crash, since most people are running without IOMMU
anyway, a misbehaving device can cause otherwise undetectable chaos.

I'd say:
  a) For CoCo, a guest (guaranteed) crash isn't a problem - CoCo doesn't
  guarantee forward progress or stop the hypervisor doing something
  truly stupid.

  b) For CoCo, information disclosure, or corruption IS a problem

  c) For non-CoCo some people might care about robustness of the kernel
  against a failing PCI device, but generally I think they worry about
  a fairly clean failure, even in the unexpected-hot unplug case.

  d) It's not clear to me what 'trust' means in terms of CoCo for a PCIe
  device; if it's a device that attests OK and we trust it is the device
  it says it is, do we give it freedom or are we still wary?

Dave


> Best Regards,
> Elena.
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

