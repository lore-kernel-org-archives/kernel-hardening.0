Return-Path: <kernel-hardening-return-21636-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6F26EC636D7
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Feb 2023 13:16:02 +0000 (UTC)
Received: (qmail 7780 invoked by uid 550); 1 Feb 2023 13:15:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7755 invoked from network); 1 Feb 2023 13:15:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675257337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TuBqixMPKWxnPBTMnq1Nfj6hQ7ImQpAmvCw/eCWpqas=;
	b=Hwwx5BU8YtSEI6m+dxeSPh/wYMPKxMbtGmNh/W7OQIuhd1z8v+he97XCZkQ+Nxh6Jkojmk
	p4bVMBOoHHdojCNXTu3xO1hR7rhMVhJ0Zh5RMbnSisCRYQVSwN8uyZnqHbXynjg2AhAC7K
	I8dWN0zQkfTNDdDGZgInysBv0mznrC4=
X-MC-Unique: WqAVsC3QOimQOiMFOFc9mg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EWfFEZdhE1A/cXIjzxKCqMf/WvuYInwDL2AiiiAEKfw=;
        b=gCccCwlo4iemORZRk38kky3zfIv4ioh01KxPVzGBExuzSkek0mF9x1Y2e8G94wmDkn
         r7K+4/K8M292pDpha1xa7xIdvuNpHVbmMhuHiehrNT/HDjuPxdltk4CurUegNTvxxYjR
         6K0W5xNhYIX/z6z0QyMf6zCGSi03LAO/62NRP8VtZGyIavipV7NZSEy+hBILZCuiF+lg
         CY18shBjcanFj62A+MDPoccOst9bHt1bnJJ5lkwmNjyHeiMBei3g5to6x4CkpWaCVQxJ
         qOHFfUwVtkYZvhZh9pqnAp24FCDyjaXCk/CZ7jIXvFnJOi8ERbSvz42GoZHA+YG2AHOw
         S4uw==
X-Gm-Message-State: AO0yUKUYp9D0th1fImkENcx3Ybjnm3rQ3X8HCVv7LHbJ9d0oTrkV5I/u
	/DJDh10exXZCO9qHn+HSv+zAi+W+w0yw1hCRZRC/dlmBmJRERpuOPqn7eh5nWFXIZMkCxq8bldK
	XBj4FUnnNXlMLhyg+UkBM6dmxS5kzqMW3Yw==
X-Received: by 2002:ac8:7f01:0:b0:3b8:6075:5d12 with SMTP id f1-20020ac87f01000000b003b860755d12mr3455278qtk.54.1675257330362;
        Wed, 01 Feb 2023 05:15:30 -0800 (PST)
X-Google-Smtp-Source: AK7set94pnyu+kUA+PTDrBbulJQp2GPpV3LzoZv6tfk4SJuG8C8yQkpTLZ4AVVgewlJKPQv+LTI/1w==
X-Received: by 2002:ac8:7f01:0:b0:3b8:6075:5d12 with SMTP id f1-20020ac87f01000000b003b860755d12mr3455215qtk.54.1675257329912;
        Wed, 01 Feb 2023 05:15:29 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: Linux guest kernel threat model for Confidential Computing
From: Christophe de Dinechin Dupont de Dinechin <cdupontd@redhat.com>
In-Reply-To: <20230201055412-mutt-send-email-mst@kernel.org>
Date: Wed, 1 Feb 2023 14:15:10 +0100
Cc: Christophe de Dinechin <dinechin@redhat.com>,
 James Bottomley <jejb@linux.ibm.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>,
 Leon Romanovsky <leon@kernel.org>,
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
 Jason Wang <jasowang@redhat.com>,
 "Poimboe, Josh" <jpoimboe@redhat.com>,
 "aarcange@redhat.com" <aarcange@redhat.com>,
 Cfir Cohen <cfir@google.com>,
 Marc Orr <marcorr@google.com>,
 "jbachmann@google.com" <jbachmann@google.com>,
 "pgonda@google.com" <pgonda@google.com>,
 "keescook@chromium.org" <keescook@chromium.org>,
 James Morris <jmorris@namei.org>,
 Michael Kelley <mikelley@microsoft.com>,
 "Lange, Jon" <jlange@microsoft.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>
Message-Id: <4B78D161-2712-434A-8E6F-9D8BA468BB3A@redhat.com>
References: <Y9JyW5bUqV7gWmU8@unreal>
 <DM8PR11MB57507D9C941D77E148EE9E87E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <702f22df28e628d41babcf670c909f1fa1bb3c0c.camel@linux.ibm.com>
 <DM8PR11MB5750F939C0B70939AD3CBC37E7D39@DM8PR11MB5750.namprd11.prod.outlook.com>
 <220b0be95a8c733f0a6eeddc08e37977ee21d518.camel@linux.ibm.com>
 <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
 <261bc99edc43990eecb1aac4fe8005cedc495c20.camel@linux.ibm.com>
 <m2h6w6k5on.fsf@redhat.com> <20230131123033-mutt-send-email-mst@kernel.org>
 <6BCC3285-ACA3-4E38-8811-1A91C9F03852@redhat.com>
 <20230201055412-mutt-send-email-mst@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable



> On 1 Feb 2023, at 12:01, Michael S. Tsirkin <mst@redhat.com> wrote:
>=20
> On Wed, Feb 01, 2023 at 11:52:27AM +0100, Christophe de Dinechin Dupont d=
e Dinechin wrote:
>>=20
>>=20
>>> On 31 Jan 2023, at 18:39, Michael S. Tsirkin <mst@redhat.com> wrote:
>>>=20
>>> On Tue, Jan 31, 2023 at 04:14:29PM +0100, Christophe de Dinechin wrote:
>>>> Finally, security considerations that apply irrespective of whether th=
e
>>>> platform is confidential or not are also outside of the scope of this
>>>> document. This includes topics ranging from timing attacks to social
>>>> engineering.
>>>=20
>>> Why are timing attacks by hypervisor on the guest out of scope?
>>=20
>> Good point.
>>=20
>> I was thinking that mitigation against timing attacks is the same
>> irrespective of the source of the attack. However, because the HV
>> controls CPU time allocation, there are presumably attacks that
>> are made much easier through the HV. Those should be listed.
>=20
> Not just that, also because it can and does emulate some devices.
> For example, are disk encryption systems protected against timing of
> disk accesses?
> This is why some people keep saying "forget about emulated devices, requi=
re
> passthrough, include devices in the trust zone".
>=20
>>>=20
>>>> </doc>
>>>>=20
>>>> Feel free to comment and reword at will ;-)
>>>>=20
>>>>=20
>>>> 3/ PCI-as-a-threat: where does that come from
>>>>=20
>>>> Isn't there a fundamental difference, from a threat model perspective,
>>>> between a bad actor, say a rogue sysadmin dumping the guest memory (wh=
ich CC
>>>> should defeat) and compromised software feeding us bad data? I think t=
here
>>>> is: at leats inside the TCB, we can detect bad software using measurem=
ents,
>>>> and prevent it from running using attestation.  In other words, we fir=
st
>>>> check what we will run, then we run it. The security there is that we =
know
>>>> what we are running. The trust we have in the software is from testing=
,
>>>> reviewing or using it.
>>>>=20
>>>> This relies on a key aspect provided by TDX and SEV, which is that the
>>>> software being measured is largely tamper-resistant thanks to memory
>>>> encryption. In other words, after you have measured your guest softwar=
e
>>>> stack, the host or hypervisor cannot willy-nilly change it.
>>>>=20
>>>> So this brings me to the next question: is there any way we could offe=
r the
>>>> same kind of service for KVM and qemu? The measurement part seems rela=
tively
>>>> easy. Thetamper-resistant part, on the other hand, seems quite difficu=
lt to
>>>> me. But maybe someone else will have a brilliant idea?
>>>>=20
>>>> So I'm asking the question, because if you could somehow prove to the =
guest
>>>> not only that it's running the right guest stack (as we can do today) =
but
>>>> also a known host/KVM/hypervisor stack, we would also switch the poten=
tial
>>>> issues with PCI, MSRs and the like from "malicious" to merely "bogus",=
 and
>>>> this is something which is evidently easier to deal with.
>>>=20
>>> Agree absolutely that's much easier.
>>>=20
>>>> I briefly discussed this with James, and he pointed out two interestin=
g
>>>> aspects of that question:
>>>>=20
>>>> 1/ In the CC world, we don't really care about *virtual* PCI devices. =
We
>>>>  care about either virtio devices, or physical ones being passed throu=
gh
>>>>  to the guest. Let's assume physical ones can be trusted, see above.
>>>>  That leaves virtio devices. How much damage can a malicious virtio de=
vice
>>>>  do to the guest kernel, and can this lead to secrets being leaked?
>>>>=20
>>>> 2/ He was not as negative as I anticipated on the possibility of someh=
ow
>>>>  being able to prevent tampering of the guest. One example he mentione=
d is
>>>>  a research paper [1] about running the hypervisor itself inside an
>>>>  "outer" TCB, using VMPLs on AMD. Maybe something similar can be achie=
ved
>>>>  with TDX using secure enclaves or some other mechanism?
>>>=20
>>> Or even just secureboot based root of trust?
>>=20
>> You mean host secureboot? Or guest?
>>=20
>> If it=E2=80=99s host, then the problem is detecting malicious tampering =
with
>> host code (whether it=E2=80=99s kernel or hypervisor).
>=20
> Host.  Lots of existing systems do this.  As an extreme boot a RO disk,
> limit which packages are allowed.

Is that provable to the guest?

Consider a cloud provider doing that: how do they prove to their guest:

a) What firmware, kernel and kvm they run

b) That what they booted cannot be maliciouly modified, e.g. by a rogue
   device driver installed by a rogue sysadmin

My understanding is that SecureBoot is only intended to prevent non-verifie=
d
operating systems from booting. So the proof is given to the cloud provider=
,
and the proof is that the system boots successfully.

After that, I think all bets are off. SecureBoot does little AFAICT
to prevent malicious modifications of the running system by someone with
root access, including deliberately loading a malicious kvm-zilog.ko

It does not mean it cannot be done, just that I don=E2=80=99t think we
have the tools at the moment.

>=20
>> If it=E2=80=99s guest, at the moment at least, the measurements do not e=
xtend
>> beyond the TCB.
>>=20
>>>=20
>>> --=20
>>> MST


