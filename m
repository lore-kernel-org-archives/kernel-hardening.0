Return-Path: <kernel-hardening-return-21617-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 9EC79C54EAA
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Jan 2023 10:15:53 +0000 (UTC)
Received: (qmail 21862 invoked by uid 550); 27 Jan 2023 10:15:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14216 invoked from network); 27 Jan 2023 10:04:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674813860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C7k+0JyRd7Jj4+JGuTlvRsODVs1VUz6inKc9+6lWrs4=;
	b=S02KutXOhJyybZ/MQoKOtcQ3L1VZPYAwCi/qtORzyb0ZxWRRaMTIT794M634VKr3Lbmlsy
	mPJnDJeZmny0qoQJkxw3o1EXDsZIIWHqUyCL2MWk4uhAvxwcywBsHFuVGlmCLdYCZ1mQ8b
	3Jka5EV1P1tAadWqS9cf256g9jmZb5w=
X-MC-Unique: vtNS3wMVOLGQtgep09qN2g-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C7k+0JyRd7Jj4+JGuTlvRsODVs1VUz6inKc9+6lWrs4=;
        b=hFEHRcq7KDjrLKFOs28bMm7XRF4XtNflr/OIu7ZGvKHNDknBhdO1581g0pe/AGwvke
         4a5iKNxyZdX6ixFRNUNL9Lv88sBpREtC/9n3qdR90fxsfIbgg/rbxXoqgh37LPZW33In
         XeeJduEE0vX5ed4ZWDJPASGvup39A+pC2jzjd12im2OEyXCxkk7fQAjEeCW7vNKhHYl3
         Qcb7S6fRcxW00Wxtwla2CRohDeoG4IT/gxhbLFNPPzhzyauijUNxWLT65stD06BjocCE
         0MOzSAw7vTgshIIGCjBDJhNy63lmUg6EgNl/Rv1dHdlcIOxmGYxzw9YCEdnroclSExmY
         lsUA==
X-Gm-Message-State: AFqh2kq8k1gOcf3npsaRXbWzUC+UauejFoBG407MkLOeH1MvaEH8xtc4
	Bkn5r9FUVPFB2h1ShN2n3DSqHKYrXQbKdco3DMsFgk1Ar/nb8/Po1buo/3FsLKXtP59G+2JeRh8
	HjLi5UsVLIVjsaYxUeWYccyLBqgXFx/mTAQ==
X-Received: by 2002:a05:600c:a52:b0:3db:122c:1638 with SMTP id c18-20020a05600c0a5200b003db122c1638mr34649464wmq.27.1674813858159;
        Fri, 27 Jan 2023 02:04:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvJqy11IfUQQTbG2B8vHqiaJJ8gQRORP7iVkIPKkozNg7BhdJTGN3sIDmVxrNgk1mSSJzu9FA==
X-Received: by 2002:a05:600c:a52:b0:3db:122c:1638 with SMTP id c18-20020a05600c0a5200b003db122c1638mr34649436wmq.27.1674813857820;
        Fri, 27 Jan 2023 02:04:17 -0800 (PST)
Date: Fri, 27 Jan 2023 05:04:12 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Shishkin, Alexander" <alexander.shishkin@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Kuppuswamy, Sathyanarayanan" <sathyanarayanan.kuppuswamy@intel.com>,
	"Kleen, Andi" <andi.kleen@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Wunner, Lukas" <lukas.wunner@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
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
Message-ID: <20230127044508-mutt-send-email-mst@kernel.org>
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <20230126105618-mutt-send-email-mst@kernel.org>
 <DM8PR11MB5750678B5F639F6C2848FC3CE7CC9@DM8PR11MB5750.namprd11.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <DM8PR11MB5750678B5F639F6C2848FC3CE7CC9@DM8PR11MB5750.namprd11.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jan 27, 2023 at 08:52:22AM +0000, Reshetova, Elena wrote:
> > On Wed, Jan 25, 2023 at 03:29:07PM +0000, Reshetova, Elena wrote:
> > > And this is a very special aspect of 'hardening' since it is about hardening a
> > kernel
> > > under different threat model/assumptions.
> > 
> > I am not sure it's that special in that hardening IMHO is not a specific
> > threat model or a set of assumptions. IIUC it's just something that
> > helps reduce severity of vulnerabilities.  Similarly, one can use the CC
> > hardware in a variety of ways I guess. And one way is just that -
> > hardening linux such that ability to corrupt guest memory does not
> > automatically escalate into guest code execution.
> 
> I am not sure if I fully follow you on this. I do agree that it is in principle
> the same 'hardening' that we have been doing in Linux for decades just
> applied to a new attack surface, host <-> guest, vs userspace <->kernel.

Sorry about being unclear this is not the type of hardening I meant
really.  The "hardening" you meant is preventing kernel vulnerabilities,
right? This is what we've been doing for decades.
But I meant slightly newer things like e.g. KASLR or indeed ASLR generally -
we are trying to reduce a chance a vulnerability causes random
code execution as opposed to a DOS. To think in these terms you do not
need to think about attack surfaces - in the system including
a hypervisor, guest supervisor and guest userspace hiding
one component from others is helpful even if they share
a privelege level.



> Interfaces have changed, but the types of vulnerabilities, etc are the same.
> The attacker model is somewhat different because we have 
> different expectations on what host/hypervisor should be able to do
> to the guest (following business reasons and use-cases), versus what we
> expect normal userspace being able to "do" towards kernel. The host and
> hypervisor still has a lot of control over the guest (ability to start/stop it, 
> manage its resources, etc). But the reasons behind this doesn’t come
> from the fact that security CoCo HW not being able to support this stricter
> security model (it cannot now indeed, but this is a design decision), but
> from the fact that it is important for Cloud service providers to retain that
> level of control over their infrastructure. 

Surely they need ability to control resource usage, not ability to execute DOS
attacks. Current hardware just does not have ability to allow the former
without the later.

> > 
> > If you put it this way, you get to participate in a well understood
> > problem space instead of constantly saying "yes but CC is special".  And
> > further, you will now talk about features as opposed to fixing bugs.
> > Which will stop annoying people who currently seem annoyed by the
> > implication that their code is buggy simply because it does not cache in
> > memory all data read from hardware. Finally, you then don't really need
> > to explain why e.g. DoS is not a problem but info leak is a problem - when
> > for many users it's actually the reverse - the reason is not that it's
> > not part of a threat model - which then makes you work hard to define
> > the threat model - but simply that CC hardware does not support this
> > kind of hardening.
> 
> But this won't be correct statement, because it is not limitation of HW, but the
> threat and business model that Confidential Computing exists in. I am not 
> aware of a single cloud provider who would be willing to use the HW that
> takes the full control of their infrastructure and running confidential guests,
> leaving them with no mechanisms to control the load balancing, enforce
> resource usage, etc. So, given that nobody needs/willing to use such HW, 
> such HW simply doesn’t exist. 
> 
> So, I would still say that the model we operate in CoCo usecases is somewhat
> special, but I do agree that given that we list a couple of these special assumptions
> (over which ones we have no control or ability to influence, none of us are business
> people), then the rest becomes just careful enumeration of attack surface interfaces
> and break up of potential mitigations. 
> 
> Best Regards,
> Elena.
> 

I'd say each business has a slightly different business model, no?
Finding common ground is what helps us share code ...

-- 
MST

