Return-Path: <kernel-hardening-return-21632-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B9C92C636CC
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Jan 2023 17:51:12 +0000 (UTC)
Received: (qmail 20454 invoked by uid 550); 31 Jan 2023 17:51:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20427 invoked from network); 31 Jan 2023 17:51:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=SSdWI2Q6EgXRJJN3L5+J3f3kteoq06xmdprIwXSPPJE=;
 b=NQxKfyMeABtFuUjxWbk40GMU36F0aVYw+8PI383rQ2WJ9hV+fLihFCW2bTeibJ7WPEwX
 BJZIDByYoemolBBr+EEarTCy2zRkLSaBAyWd4saUO7Qz1Zz8MsTKa4+OjlDblyLAGo9S
 HbT48UMI6t+J/H832tXMXHaeK+SXDQ2G5PCQGytBtuX7rlJnZroaHZZEfwOIQZEQF5vB
 guyKWpV4LQvgzICMT6ElATxx8mUSkUT3IJjT6h+NWnMcIYOD9KEpoLQlN04wUenv4b+H
 DF9TN5hQdefnw4lTo3AQI41VtdsClBxQX4HxtAReOY+OJ7NZfY5aDZGkAt2AoY7ontFz vQ== 
Message-ID: <706d1a6ad110749a9519548a2d5bebf090301586.camel@linux.ibm.com>
Subject: Re: Linux guest kernel threat model for Confidential Computing
From: James Bottomley <jejb@linux.ibm.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
        Leon Romanovsky
	 <leon@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Shishkin, Alexander"
 <alexander.shishkin@intel.com>,
        "Shutemov, Kirill"
 <kirill.shutemov@intel.com>,
        "Kuppuswamy, Sathyanarayanan"
 <sathyanarayanan.kuppuswamy@intel.com>,
        "Kleen, Andi"
 <andi.kleen@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas
 Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Wunner, Lukas" <lukas.wunner@intel.com>,
        Mika Westerberg
 <mika.westerberg@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Poimboe, Josh" <jpoimboe@redhat.com>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        Cfir Cohen <cfir@google.com>, Marc Orr <marcorr@google.com>,
        "jbachmann@google.com"
 <jbachmann@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        James Morris
 <jmorris@namei.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "Lange, Jon"
 <jlange@microsoft.com>,
        "linux-coco@lists.linux.dev"
 <linux-coco@lists.linux.dev>,
        Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>,
        Kernel Hardening
 <kernel-hardening@lists.openwall.com>
Date: Tue, 31 Jan 2023 12:49:54 -0500
In-Reply-To: <DM8PR11MB5750EC7B7FE96476BA0F652EE7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
References: 
	<DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
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
	 <DM8PR11MB5750EC7B7FE96476BA0F652EE7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wIpV78JSaQ2gvlK6paZZOBEPS4yk-4OE
X-Proofpoint-GUID: 1sY5Ys9OXj7tZuMX3rxUFDInKLKllRZB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301310155

On Tue, 2023-01-31 at 16:34 +0000, Reshetova, Elena wrote:
[...]
> > You cited this as your example.  I'm pointing out it seems to be an
> > event of the class we've agreed not to consider because it's an
> > oops not an exploit.  If there are examples of fixing actual
> > exploits to CC VMs, what are they?
> > 
> > This patch is, however, an example of the problem everyone else on
> > the thread is complaining about: a patch which adds an unnecessary
> > check to the MSI subsystem; unnecessary because it doesn't fix a CC
> > exploit and in the real world the tables are correct (or the
> > manufacturer is quickly chastened), so it adds overhead to no
> > benefit.
> 
> How can you make sure there is no exploit possible using this crash
> as a stepping stone into a CC guest?

I'm not, what I'm saying is you haven't proved it can be used to
exfiltrate secrets.  In a world where the PCI device is expected to be
correct, and the non-CC kernel doesn't want to second guess that, there
are loads of lies you can tell to the PCI subsystem that causes a crash
or a hang.  If we fix every one, we end up with a massive patch set and
a huge potential slow down for the non-CC kernel.  If there's no way to
tell what lies might leak data, the fuzzing results are a mass of noise
with no real signal and we can't even quantify by how much (or even if)
we've improved the CC VM attack surface even after we merge the huge
patch set it generates.

>  Or are you saying that we are back to the times when we can merge
> the fixes for crashes and out of bound errors in kernel only given
> that we submit a proof of concept exploit with the patch for every
> issue? 

The PCI people have already said that crashing in the face of bogus
configuration data is expected behaviour, so just generating the crash
doesn't prove there's a problem to be fixed.  That means you do have to
go beyond and demonstrate there could be an information leak in a CC VM
on the back of it, yes.

> > [...]
> > > > see what else it could detect given the signal will be
> > > > smothered by oopses and secondly I think the PCI interface is
> > > > likely the wrong place to begin and you should probably begin
> > > > on the virtio bus and the hypervisor generated configuration
> > > > space.
> > > 
> > > This is exactly what we do. We don’t fuzz from the PCI config
> > > space, we supply inputs from the host/vmm via the legitimate
> > > interfaces that it can inject them to the guest: whenever guest
> > > requests a pci config space (which is controlled by
> > > host/hypervisor as you said) read operation, it gets input
> > > injected by the kafl fuzzer.  Same for other interfaces that are
> > > under control of host/VMM (MSRs, port IO, MMIO, anything that
> > > goes via #VE handler in our case). When it comes to virtio, we
> > > employ  two different fuzzing techniques: directly injecting kafl
> > > fuzz input when virtio core or virtio drivers gets the data
> > > received from the host (via injecting input in functions
> > > virtio16/32/64_to_cpu and others) and directly fuzzing DMA memory
> > > pages using kfx fuzzer. More information can be found in
> > > https://intel.github.io/ccc-linux-guest-hardening-docs/tdx-guest-
> > hardening.html#td-guest-fuzzing
> > 
> > Given that we previously agreed that oppses and other DoS attacks
> > are out of scope for CC, I really don't think fuzzing, which
> > primarily finds oopses, is at all a useful tool unless you filter
> > the results by the question "could we exploit this in a CC VM to
> > reveal secrets". Without applying that filter you're sending a load
> > of patches which don't really do much to reduce the CC attack
> > surface and which do annoy non-CC people because they add pointless
> > checks to things they expect the cards and config tables to get
> > right.
> 
> I don’t think we have agreed that random kernel crashes are out of
> scope in CC threat model (controlled safe panic is out of scope, but
> this is not what we have here). 

So perhaps making it a controlled panic in the CC VM, so we can
guarantee no information leak, would be the first place to start?

> It all depends if this ops can be used in a successful attack against
> guest private memory or not and this is *not* a trivial thing to
> decide.

Right, but if you can't decide that, you can't extract the signal from
your fuzzing tool noise.

> That's said, we are mostly focusing on KASAN findings, which
> have higher likelihood to be exploitable at least for host -> guest
> privilege escalation (which in turn compromised guest private memory
> confidentiality). Fuzzing has a long history of find such issues in
> past (including the ones that have been exploited after). But even
> for this ops bug, can anyone guarantee it cannot be chained with
> other ones to cause a more complex privilege escalation attack?
> I wont be making such a claim, I feel it is safer to fix this vs
> debating whenever it can be used for an attack or not. 

The PCI people have already been clear that adding a huge framework of
checks to PCI table parsing simply for the promise it "might possibly"
improve CC VM security is way too much effort for too little result. 
If you can hone that down to a few places where you can show it will
prevent a CC information leak, I'm sure they'll be more receptive. 
Telling them to disprove your assertion that there might be an exploit
here isn't going to make them change their minds.

James

