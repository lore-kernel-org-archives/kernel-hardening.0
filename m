Return-Path: <kernel-hardening-return-21639-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 8F18FC05027
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Feb 2023 11:18:40 +0000 (UTC)
Received: (qmail 3887 invoked by uid 550); 2 Feb 2023 11:18:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18260 invoked from network); 2 Feb 2023 03:25:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675308306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iY/OQt8yhAuJl9finL5LdlRPRN18tAZGyT7vixhBhhY=;
	b=JeuQCWKjFTRMNvFK9NtRLZ2vuluv9pigLDy586eGy+W/D0SH4T98xrFh9je3zKyKZCFofB
	8x5/pc7nodkXicwaKksxjZ6OSUmnNiU2pdl2ySL/Acxgi6eEu/kOGh3d8T6Pi5PUMoWyTw
	TXa4pswdUM9i3pTLWMYitzNRsl2/8pA=
X-MC-Unique: wS7UbJogOyKoC_HYOb4Irw-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iY/OQt8yhAuJl9finL5LdlRPRN18tAZGyT7vixhBhhY=;
        b=Ls/dBDjie1yHFZkGrVOn3byJIW6hm5IYaqWJ6w6AMCW4x2McZVS1ba/2txrD2LV+40
         krnhl+/t+Mhwhe9l8mV4elReukCYvabSTRVqs3dm2v1+YfcEgNqTRC7OfeJhQYq/AsXp
         Koc+C/Ig3OxPXCmUalFKERNWWZmkXcWK2NNDog1CLrJ7D1AowFQBkdHd7a7Oqd56Xaly
         y7dWko8UmZ2IOvB/UUqKi2egz+MKShULjnac/ob+aGKkyMJEDn1eEWsVWgS/iUWaW79N
         8wTI0cN12Tyfeln8eVQL7wJZABgrlVBToTdDH1WfvgXd3/0iAKrvi7ULNBYXwd6BOHdY
         72jA==
X-Gm-Message-State: AO0yUKURX3nnyoThwxqrvgVk/vRSZHrvwTgl3pHEYKq4s9oKwPUKSZyi
	Jtu7C+mWweF9yq/uAAR6PxxPvGMO6gRejrv7+EYC23qgRfzbOazVxPZ+YM7EONLFhLNy5f+VWJh
	Exq5QRX/OpA77wXEZbubpzwHvV5IS7OjnTw==
X-Received: by 2002:a17:902:ecd0:b0:196:8445:56be with SMTP id a16-20020a170902ecd000b00196844556bemr5788465plh.42.1675308302933;
        Wed, 01 Feb 2023 19:25:02 -0800 (PST)
X-Google-Smtp-Source: AK7set/pvefWS1/CpqW1NscmlurIGYYGDzwh8/dBgY5gfye1noE+4RvwU+vANRnhJEPiWLcmieADdw==
X-Received: by 2002:a17:902:ecd0:b0:196:8445:56be with SMTP id a16-20020a170902ecd000b00196844556bemr5788421plh.42.1675308302560;
        Wed, 01 Feb 2023 19:25:02 -0800 (PST)
Message-ID: <f9651a67-e3c2-9cee-5863-cb3f15a507be@redhat.com>
Date: Thu, 2 Feb 2023 11:24:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: Linux guest kernel threat model for Confidential Computing
To: "Michael S. Tsirkin" <mst@redhat.com>,
 Christophe de Dinechin Dupont de Dinechin <cdupontd@redhat.com>
Cc: Christophe de Dinechin <dinechin@redhat.com>,
 James Bottomley <jejb@linux.ibm.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>,
 Leon Romanovsky <leon@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Shishkin, Alexander" <alexander.shishkin@intel.com>,
 "Shutemov, Kirill" <kirill.shutemov@intel.com>,
 "Kuppuswamy, Sathyanarayanan" <sathyanarayanan.kuppuswamy@intel.com>,
 "Kleen, Andi" <andi.kleen@intel.com>, "Hansen, Dave"
 <dave.hansen@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Peter Zijlstra <peterz@infradead.org>, "Wunner, Lukas"
 <lukas.wunner@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>,
 "Poimboe, Josh" <jpoimboe@redhat.com>,
 "aarcange@redhat.com" <aarcange@redhat.com>, Cfir Cohen <cfir@google.com>,
 Marc Orr <marcorr@google.com>, "jbachmann@google.com"
 <jbachmann@google.com>, "pgonda@google.com" <pgonda@google.com>,
 "keescook@chromium.org" <keescook@chromium.org>,
 James Morris <jmorris@namei.org>, Michael Kelley <mikelley@microsoft.com>,
 "Lange, Jon" <jlange@microsoft.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>
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
From: Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230201055412-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2023/2/1 19:01, Michael S. Tsirkin 写道:
> On Wed, Feb 01, 2023 at 11:52:27AM +0100, Christophe de Dinechin Dupont de Dinechin wrote:
>>
>>> On 31 Jan 2023, at 18:39, Michael S. Tsirkin <mst@redhat.com> wrote:
>>>
>>> On Tue, Jan 31, 2023 at 04:14:29PM +0100, Christophe de Dinechin wrote:
>>>> Finally, security considerations that apply irrespective of whether the
>>>> platform is confidential or not are also outside of the scope of this
>>>> document. This includes topics ranging from timing attacks to social
>>>> engineering.
>>> Why are timing attacks by hypervisor on the guest out of scope?
>> Good point.
>>
>> I was thinking that mitigation against timing attacks is the same
>> irrespective of the source of the attack. However, because the HV
>> controls CPU time allocation, there are presumably attacks that
>> are made much easier through the HV. Those should be listed.
> Not just that, also because it can and does emulate some devices.
> For example, are disk encryption systems protected against timing of
> disk accesses?
> This is why some people keep saying "forget about emulated devices, require
> passthrough, include devices in the trust zone".


One problem is that the device could be yet another emulated one that is 
running in the SmartNIC/DPU itself.

Thanks


