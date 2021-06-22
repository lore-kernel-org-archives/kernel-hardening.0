Return-Path: <SRS0=mpp+=LQ=lists.openwall.com=kernel-hardening-return-21314-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F444C4743C
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Jun 2021 02:53:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 01CF46101D
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Jun 2021 02:53:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01CF46101D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21314-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9530 invoked by uid 550); 22 Jun 2021 02:52:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9507 invoked from network); 22 Jun 2021 02:52:52 -0000
Date: Tue, 22 Jun 2021 12:46:43 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
cc: linux-kernel@vger.kernel.org, lwn@lwn.net, fedora-selinux-list@redhat.com, 
    linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com, 
    linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
    Audit-ML <linux-audit@redhat.com>, gentoo-hardened@gentoo.org, 
    keyrings@linux-nfs.org, tpmdd-devel@lists.sourceforge.net, 
    Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>
Subject: Re: [ANNOUNCE][CFP] Linux Security Summit 2021
In-Reply-To: <5b3a0bf-226d-6ee-d0b-d6673eff32b2@namei.org>
Message-ID: <2db579ee-1d1c-102c-c2d4-c268d89aae8c@namei.org>
References: <c244f77-56a1-c089-521d-2e670488c10@namei.org> <5b3a0bf-226d-6ee-d0b-d6673eff32b2@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Two further (and hopefully final) changes:

  - LSS 2021 will now be a hybrid event, catering to both in-person and 
    remote attendees and presenters

  - The CFP is extended to July 11th.



On Wed, 26 May 2021, James Morris wrote:

> Note that the venue of LSS 2021 has now changed to Seattle, USA.
> 
> See https://events.linuxfoundation.org/linux-security-summit-north-america/
> 
> The new event dates are 29 September to 01 October.
> 
> The CFP closes on June 27th.
> 
> 
> 
> 
> 
> On Tue, 9 Feb 2021, James Morris wrote:
> 
> > ==============================================================================
> >                    ANNOUNCEMENT AND CALL FOR PARTICIPATION
> > 
> >                          LINUX SECURITY SUMMIT 2021
> >                              
> >                               27-29 September
> >                               Dublin, Ireland
> > ==============================================================================
> > 
> > DESCRIPTION
> >  
> > Linux Security Summit (LSS) is a technical forum for collaboration between
> > Linux developers, researchers, and end-users.  Its primary aim is to foster
> > community efforts in analyzing and solving Linux security challenges.
> > 
> >  The program committee currently seeks proposals for:
> >  
> >    * Refereed Presentations:
> >      45 minutes in length.
> >  
> >    * Panel Discussion Topics:
> >      45 minutes in length.
> >  
> >    * Short Topics:
> >      30 minutes in total, including at least 10 minutes discussion.
> >  
> >    * Tutorials
> >      90 minutes in length.
> >  
> > Tutorial sessions should be focused on advanced Linux security defense
> > topics within areas such as the kernel, compiler, and security-related
> > libraries.  Priority will be given to tutorials created for this conference,
> > and those where the presenter a leading subject matter expert on the topic.
> >  
> > Topic areas include, but are not limited to:
> >  
> >    * Kernel self-protection
> >    * Access control
> >    * Cryptography and key management
> >    * Integrity policy and enforcement
> >    * Hardware Security
> >    * IoT and embedded security
> >    * Virtualization and containers
> >    * System-specific system hardening
> >    * Case studies
> >    * Security tools
> >    * Security UX
> >    * Emerging technologies, threats & techniques
> > 
> >   Proposals should be submitted via:
> >     https://events.linuxfoundation.org/linux-security-summit-europe/program/cfp/
> > 
> > 
> > ** Note that for 2021, the North American and European events are combined into
> > a single event planned for Dublin, Ireland. **
> >  
> > 
> > DATES
> >  
> >   * CFP close:            June 27
> >   * CFP notifications:    July 20
> >   * Schedule announced:   July 22
> >   * Event:                September 27-29
> > 
> > WHO SHOULD ATTEND
> >  
> > We're seeking a diverse range of attendees and welcome participation by
> > people involved in Linux security development, operations, and research.
> >  
> > LSS is a unique global event that provides the opportunity to present and
> > discuss your work or research with key Linux security community members and
> > maintainers.  It's also useful for those who wish to keep up with the latest
> > in Linux security development and to provide input to the development
> > process.
> > 
> > WEB SITE
> > 
> >     https://events.linuxfoundation.org/linux-security-summit-europe/
> > 
> > TWITTER
> > 
> >   For event updates and announcements, follow:
> > 
> >     https://twitter.com/LinuxSecSummit
> >   
> >     #linuxsecuritysummit
> > 
> > PROGRAM COMMITTEE
> > 
> >   The program committee for LSS 2021 is:
> > 
> >     * James Morris, Microsoft
> >     * Serge Hallyn, Cisco
> >     * Paul Moore, Cisco
> >     * Stephen Smalley, NSA
> >     * Elena Reshetova, Intel
> >     * John Johansen, Canonical
> >     * Kees Cook, Google
> >     * Casey Schaufler, Intel
> >     * Mimi Zohar, IBM
> >     * David A. Wheeler, Institute for Defense Analyses
> > 
> >   The program committee may be contacted as a group via email:
> >     lss-pc () lists.linuxfoundation.org
> > 
> > 
> 
> -- 
> James Morris
> <jmorris@namei.org>
> 
> 

-- 
James Morris
<jmorris@namei.org>

