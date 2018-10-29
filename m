Subject: Re: [RFC v1 PATCH 00/17] prmem: protected memory
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181024230345.GE6311@dastard>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <aa37468e-651d-fbcd-692c-aa19d19d9f38@gmail.com>
Date: Mon, 29 Oct 2018 21:47:39 +0200
MIME-Version: 1.0
In-Reply-To: <20181024230345.GE6311@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 25/10/2018 00:03, Dave Chinner wrote:
> On Wed, Oct 24, 2018 at 12:34:47AM +0300, Igor Stoppa wrote:
>> -- Summary --
>>
>> Preliminary version of memory protection patchset, including a sample use
>> case, turning into write-rare the IMA measurement list.
> 
> I haven't looked at the patches yet, but I see a significant issue
> from the subject lines. "prmem" is very similar to "pmem"
> (persistent memory) and that's going to cause confusion. Especially
> if people start talking about prmem and pmem in the context of write
> protect pmem with prmem...
> 
> Naming is hard :/

yes, at some point I had to go from rare-write to write-rare because I 
realized that the acronym "rw" was likely to be interpreted as "read/write"

I propose to keep prmem for the time being, just to avoid adding extra 
changes that are not functional.
Once the code has somewhat settled down, I can proceed with the 
renaming. In the meanwhile, a better name could be discussed.

For example, would "prmemory" be sufficiently unambiguous?

--
igor
