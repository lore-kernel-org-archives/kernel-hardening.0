Return-Path: <kernel-hardening-return-21616-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 9C637C54EAA
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Jan 2023 09:50:17 +0000 (UTC)
Received: (qmail 29700 invoked by uid 550); 27 Jan 2023 09:49:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7760 invoked from network); 27 Jan 2023 09:32:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1674811928;
	bh=67bxT685tOMCKAuJAdCEHl033uhA9K3HKNmu6VQru0o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xy2SiDytMo1wuCsna2qB+MFrsDdSUGfO4h3fBDUHGer8n9OqFrq+zLxIRp+wKeAYo
	 WCVqiNKU6o1RRx1foLikfKWDJwZt7NwWDdp61ni8YITCQDLrxwK/xKJY/7Kh6jld2J
	 6gI6pHCgNx0DKaD83QIW6gJiQ2Y4LoPLOeMlEm7ubDS/7+HWcWp54nRFCZIFGQDAv/
	 ORUp7me4GZTaXozH+WunuCriokj9YOcsnT7+ArGFYptfdBY0d8JECpKDgq7crBUyRr
	 Ik/dGWmFIoQkkpqiK+D4tjKbjmmfELjWZ/PRIXbcu+2Vpg45hCdyLBDTz0L/+3ucai
	 46QWyEJ19LB8A==
Date: Fri, 27 Jan 2023 10:32:07 +0100
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
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
Message-ID: <Y9OaF/p6PszOCydn@8bytes.org>
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9Jh2x9XJE1KEUg6@unreal>
 <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9JyW5bUqV7gWmU8@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9JyW5bUqV7gWmU8@unreal>

On Thu, Jan 26, 2023 at 02:30:19PM +0200, Leon Romanovsky wrote:
> This is exactly what I said. You presented me the cases which exist in
> your invented world. Mentioned unhandled page fault doesn't exist in real
> world. If PCI device doesn't work, it needs to be replaced/blocked and not
> left to be operable and accessible from the kernel/user.

Believe it or not, this "invented" world is already part of the real
world, and will become even more in the future.

So this has been stated elsewhere in the thread already, but I also like
to stress that hiding misbehavior of devices (real or emulated) is not
the goal of this work.

In fact, the best action for a CoCo guest in case it detects a
(possible) attack is to stop whatever it is doing and crash. And a
misbehaving device in a CoCo guest is a possible attack.

But what needs to be prevented at all costs is undefined behavior in the
CoCo guest that is triggerable by the HV, e.g. by letting an emulated
device misbehave. That undefined behavior can lead to information leak,
which is a way bigger problem for a guest owner than a crashed VM.

Regards,

	Joerg
