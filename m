Return-Path: <kernel-hardening-return-21633-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6A3A8C636D3
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Feb 2023 10:27:17 +0000 (UTC)
Received: (qmail 14070 invoked by uid 550); 1 Feb 2023 10:27:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14037 invoked from network); 1 Feb 2023 10:27:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675247215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DPtpc99gkZd9FdSESMXJ3jxwAkpCCqpdtDcKKsBodDo=;
	b=Buhq2Ma03caOYbQSSneruz+LhHILvOxcwa8fvwznas6pNfNiblF5yjg9isv+3UpWmVkNQV
	nIqUAzKlcK2bNX+UNddN7ePjoNb3wwJL+zz/L937syv7zL+AyEuvNyjN6CDtRhfbEx/4q9
	MbDnzZ9Qv9Ty+QG9kGahUg8rzVikPuA=
X-MC-Unique: yjdN_6KLOA-XaNjlJMXImA-1
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9Jh2x9XJE1KEUg6@unreal>
 <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9JyW5bUqV7gWmU8@unreal>
 <DM8PR11MB57507D9C941D77E148EE9E87E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <702f22df28e628d41babcf670c909f1fa1bb3c0c.camel@linux.ibm.com>
 <DM8PR11MB5750F939C0B70939AD3CBC37E7D39@DM8PR11MB5750.namprd11.prod.outlook.com>
 <220b0be95a8c733f0a6eeddc08e37977ee21d518.camel@linux.ibm.com>
 <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
 <261bc99edc43990eecb1aac4fe8005cedc495c20.camel@linux.ibm.com>
 <m2h6w6k5on.fsf@redhat.com>
User-agent: mu4e 1.8.0; emacs 28.2
From: Christophe de Dinechin <dinechin@redhat.com>
To: jejb@linux.ibm.com
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, Leon Romanovsky
 <leon@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Shishkin, Alexander" <alexander.shishkin@intel.com>, "Shutemov, Kirill"
 <kirill.shutemov@intel.com>, "Kuppuswamy, Sathyanarayanan"
 <sathyanarayanan.kuppuswamy@intel.com>, "Kleen, Andi"
 <andi.kleen@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, Thomas
   Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 "Wunner, Lukas" <lukas.wunner@intel.com>, Mika Westerberg
 <mika.westerberg@linux.intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, "Poimboe, Josh" <jpoimboe@redhat.com>,
 "aarcange@redhat.com" <aarcange@redhat.com>, Cfir Cohen <cfir@google.com>,
 Marc Orr <marcorr@google.com>, "jbachmann@google.com"
 <jbachmann@google.com>, "pgonda@google.com" <pgonda@google.com>,
 "keescook@chromium.org" <keescook@chromium.org>, James Morris
 <jmorris@namei.org>, Michael Kelley <mikelley@microsoft.com>, "Lange, Jon"
 <jlange@microsoft.com>, "linux-coco@lists.linux.dev"
 <linux-coco@lists.linux.dev>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>
Subject: Re: Linux guest kernel threat model for Confidential Computing
Date: Wed, 01 Feb 2023 11:24:21 +0100
In-reply-to: <m2h6w6k5on.fsf@redhat.com>
Message-ID: <m28rhhk7fi.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

I typoed a lot in this email...


On 2023-01-31 at 16:14 +01, Christophe de Dinechin <dinechin@redhat.com> wr=
ote...
> On 2023-01-31 at 08:28 -05, James Bottomley <jejb@linux.ibm.com> wrote...
>> On Tue, 2023-01-31 at 11:31 +0000, Reshetova, Elena wrote:
>>> > On Mon, 2023-01-30 at 07:42 +0000, Reshetova, Elena wrote:
>>> > [...]
>>> > > > The big threat from most devices (including the thunderbolt
>>> > > > classes) is that they can DMA all over memory.=C2=A0 However, this
>>> > > > isn't really a threat in CC (well until PCI becomes able to do
>>> > > > encrypted DMA) because the device has specific unencrypted
>>> > > > buffers set aside for the expected DMA. If it writes outside
>>> > > > that CC integrity will detect it and if it reads outside that
>>> > > > it gets unintelligible ciphertext.=C2=A0 So we're left with the
>>> > > > device trying to trick secrets out of us by returning
>>> > > > unexpected data.
>>> > >
>>> > > Yes, by supplying the input that hasn=E2=80=99t been expected. This=
 is
>>> > > exactly the case we were trying to fix here for example:
>>> > > https://lore.kernel.org/all/20230119170633.40944-2-
>>> > alexander.shishkin@linux.intel.com/
>>> > > I do agree that this case is less severe when others where memory
>>> > > corruption/buffer overrun can happen, like here:
>>> > > https://lore.kernel.org/all/20230119135721.83345-6-
>>> > alexander.shishkin@linux.intel.com/
>>> > > But we are trying to fix all issues we see now (prioritizing the
>>> > > second ones though).
>>> >
>>> > I don't see how MSI table sizing is a bug in the category we've
>>> > defined.=C2=A0 The very text of the changelog says "resulting in a
>>> > kernel page fault in pci_write_msg_msix()."=C2=A0 which is a crash,
>>> > which I thought we were agreeing was out of scope for CC attacks?
>>>
>>> As I said this is an example of a crash and on the first look
>>> might not lead to the exploitable condition (albeit attackers are
>>> creative). But we noticed this one while fuzzing and it was common
>>> enough that prevented fuzzer going deeper into the virtio devices
>>> driver fuzzing. The core PCI/MSI doesn=E2=80=99t seem to have that many
>>> easily triggerable Other examples in virtio patchset are more severe.
>>
>> You cited this as your example.  I'm pointing out it seems to be an
>> event of the class we've agreed not to consider because it's an oops
>> not an exploit.  If there are examples of fixing actual exploits to CC
>> VMs, what are they?
>>
>> This patch is, however, an example of the problem everyone else on the
>> thread is complaining about: a patch which adds an unnecessary check to
>> the MSI subsystem; unnecessary because it doesn't fix a CC exploit and
>> in the real world the tables are correct (or the manufacturer is
>> quickly chastened), so it adds overhead to no benefit.
>
> I'd like to backtrack a little here.
>
>
> 1/ PCI-as-a-thread, where does it come from?

PCI-as-a-threat

>
> On physical devices, we have to assume that the device is working. As oth=
er
> pointed out, there are things like PCI compliance tests, etc. So Linux has
> to trust the device. You could manufacture a broken device intentionally,
> but the value you would get from that would be limited.
>
> On a CC system, the "PCI" values are really provided by the hypervisor,
> which is not trusted. This leads to this peculiar way of thinking where we
> say "what happens if virtual device feeds us a bogus value *intentionally=
*".
> We cannot assume that the *virtual* PCI device ran through the compliance
> tests. Instead, we see the PCI interface as hostile, which makes us look
> like weirdos to the rest of the community.
>
> Consequently, as James pointed out, we first need to focus on consequences
> that would break what I would call the "CC promise", which is essentially
> that we'd rather kill the guest than reveal its secrets. Unless you have a
> credible path to a secret being revealed, don't bother "fixing" a bug. And
> as was pointed out elsewhere in this thread, caching has a cost, so you
> can't really use the "optimization" angle either.
>
>
> 2/ Clarification of the "CC promise" and value proposition
>
> Based on the above, the very first thing is to clarify that "CC promise",
> because if exchanges on this thread have proved anything, it is that it's
> quite unclear to anyone outside the "CoCo world".
>
> The Linux Guest Kernel Security Specification needs to really elaborate on
> what the value proposition of CC is, not assume it is a given. "Bug fixes"
> before this value proposition has been understood and accepted by the
> non-CoCo community are likely to go absolutely nowhere.
>
> Here is a quick proposal for the Purpose and Scope section:
>
> <doc>
> Purpose and Scope
>
> Confidential Computing (CC) is a set of technologies that allows a guest =
to
> run without having to trust either the hypervisor or the host. CC offers =
two
> new guarantees to the guest compared to the non-CC case:
>
> a) The guest will be able to measure and attest, by cryptographic means, =
the
>    guest software stack that it is running, and be assured that this
>    software stack cannot be tampered with by the host or the hypervisor
>    after it was measured. The root of trust for this aspect of CC is
>    typically the CPU manufacturer (e.g. through a private key that can be
>    used to respond to cryptographic challenges).
>
> b) Guest state, including memory, become secrets which must remain
>    inaccessible to the host. In a CC context, it is considered preferable=
 to
>    stop or kill a guest rather than risk leaking its secrets. This aspect=
 of
>    CC is typically enforced by means such as memory encryption and new
>    semantics for memory protection.
>
> CC leads to a different threat model for a Linux kernel running as a guest
> inside a confidential virtual machine (CVM). Notably, whereas the machine
> (CPU, I/O devices, etc) is usually considered as trustworthy, in the CC
> case, the hypervisor emulating some aspects of the virtual machine is now
> considered as potentially malicious. Consequently, effects of any data
> provided by the guest to the hypervisor, including ACPI configuration

to the guest by the hypervisor

> tables, MMIO interfaces or machine specific registers (MSRs) need to be
> re-evaluated.
>
> This document describes the security architecture of the Linux guest kern=
el
> running inside a CVM, with a particular focus on the Intel TDX
> implementation. Many aspects of this document will be applicable to other
> CC implementations such as AMD SEV.
>
> Aspects of the guest-visible state that are under direct control of the
> hardware, such as the CPU state or memory protection, will be considered =
as
> being handled by the CC implementations. This document will therefore only
> focus on aspects of the virtual machine that are typically managed by the
> hypervisor or the host.
>
> Since the host ultimately owns the resources and can allocate them at wil=
l,
> including denying their use at any point, this document will not address
> denial or service or performance degradation. It will however cover random
> number generation, which is central for cryptographic security.
>
> Finally, security considerations that apply irrespective of whether the
> platform is confidential or not are also outside of the scope of this
> document. This includes topics ranging from timing attacks to social
> engineering.
> </doc>
>
> Feel free to comment and reword at will ;-)
>
>
> 3/ PCI-as-a-threat: where does that come from

3/ Can we shift from "malicious" hypervisor/host input to "bogus" input?

>
> Isn't there a fundamental difference, from a threat model perspective,
> between a bad actor, say a rogue sysadmin dumping the guest memory (which=
 CC
> should defeat) and compromised software feeding us bad data? I think there
> is: at leats inside the TCB, we can detect bad software using measurement=
s,
> and prevent it from running using attestation.  In other words, we first
> check what we will run, then we run it. The security there is that we know
> what we are running. The trust we have in the software is from testing,
> reviewing or using it.
>
> This relies on a key aspect provided by TDX and SEV, which is that the
> software being measured is largely tamper-resistant thanks to memory
> encryption. In other words, after you have measured your guest software
> stack, the host or hypervisor cannot willy-nilly change it.
>
> So this brings me to the next question: is there any way we could offer t=
he
> same kind of service for KVM and qemu? The measurement part seems relativ=
ely
> easy. Thetamper-resistant part, on the other hand, seems quite difficult =
to
> me. But maybe someone else will have a brilliant idea?
>
> So I'm asking the question, because if you could somehow prove to the gue=
st
> not only that it's running the right guest stack (as we can do today) but
> also a known host/KVM/hypervisor stack, we would also switch the potential
> issues with PCI, MSRs and the like from "malicious" to merely "bogus", and
> this is something which is evidently easier to deal with.
>
> I briefly discussed this with James, and he pointed out two interesting
> aspects of that question:
>
> 1/ In the CC world, we don't really care about *virtual* PCI devices. We
>    care about either virtio devices, or physical ones being passed through
>    to the guest. Let's assume physical ones can be trusted, see above.
>    That leaves virtio devices. How much damage can a malicious virtio dev=
ice
>    do to the guest kernel, and can this lead to secrets being leaked?
>
> 2/ He was not as negative as I anticipated on the possibility of somehow
>    being able to prevent tampering of the guest. One example he mentioned=
 is
>    a research paper [1] about running the hypervisor itself inside an
>    "outer" TCB, using VMPLs on AMD. Maybe something similar can be achiev=
ed
>    with TDX using secure enclaves or some other mechanism?
>
>
> Sorry, this mail is a bit long ;-)

and was a bit rushed too...

>
>
>>
>>
>> [...]
>>> > see what else it could detect given the signal will be smothered by
>>> > oopses and secondly I think the PCI interface is likely the wrong
>>> > place to begin and you should probably begin on the virtio bus and
>>> > the hypervisor generated configuration space.
>>>
>>> This is exactly what we do. We don=E2=80=99t fuzz from the PCI config s=
pace,
>>> we supply inputs from the host/vmm via the legitimate interfaces that
>>> it can inject them to the guest: whenever guest requests a pci config
>>> space (which is controlled by host/hypervisor as you said) read
>>> operation, it gets input injected by the kafl fuzzer.=C2=A0 Same for ot=
her
>>> interfaces that are under control of host/VMM (MSRs, port IO, MMIO,
>>> anything that goes via #VE handler in our case). When it comes to
>>> virtio, we employ  two different fuzzing techniques: directly
>>> injecting kafl fuzz input when virtio core or virtio drivers gets the
>>> data received from the host (via injecting input in functions
>>> virtio16/32/64_to_cpu and others) and directly fuzzing DMA memory
>>> pages using kfx fuzzer. More information can be found in
>>> https://intel.github.io/ccc-linux-guest-hardening-docs/tdx-guest-harden=
ing.html#td-guest-fuzzing
>>
>> Given that we previously agreed that oppses and other DoS attacks are
>> out of scope for CC, I really don't think fuzzing, which primarily
>> finds oopses, is at all a useful tool unless you filter the results by
>> the question "could we exploit this in a CC VM to reveal secrets".
>> Without applying that filter you're sending a load of patches which
>> don't really do much to reduce the CC attack surface and which do annoy
>> non-CC people because they add pointless checks to things they expect
>> the cards and config tables to get right.
>
> Indeed.
>
> [1]: https://dl.acm.org/doi/abs/10.1145/3548606.3560592


--
Cheers,
Christophe de Dinechin (https://c3d.github.io)
Theory of Incomplete Measurements (https://c3d.github.io/TIM)

