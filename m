Subject: Re: [PATCH V5 0/5] KVM: X86: Introducing ROE Protection Kernel
 Hardening
References: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <1b3eb10e-c492-dc77-cbe6-3a3e692326d7@gmail.com>
Date: Mon, 29 Oct 2018 20:01:42 +0200
MIME-Version: 1.0
In-Reply-To: <20181026151223.16810-1-ahmedsoliman0x666@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ahmed Abd El Mawgood <ahmedsoliman0x666@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ovich00@gmail.com, kernel-hardening@lists.openwall.com, nigel.edwards@hpe.com, Boris Lukashev <blukashev@sempervictus.com>, Hossam Hassan <7ossam9063@gmail.com>, Ahmed Lotfy <A7med.lotfey@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On 26/10/2018 16:12, Ahmed Abd El Mawgood wrote:

> This is the 5th version which is 4th version with minor fixes. ROE is a
> hypercall that enables host operating system to restrict guest's access to its
> own memory. This will provide a hardening mechanism that can be used to stop
> rootkits from manipulating kernel static data structures and code. Once a memory
> region is protected the guest kernel can't even request undoing the protection.

This is very interesting, because it seems a very good match to the work 
I'm doing, for supporting the creation of more targets for protection:

https://www.openwall.com/lists/kernel-hardening/2018/10/23/3

In my case the protection would extend also to write-rate type of data.
There is an open problem of identifying legitimate write-rare 
operations, however it should be possible to provide at least a certain 
degree of confidence.

--

igor
