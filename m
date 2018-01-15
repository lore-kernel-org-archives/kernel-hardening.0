MIME-Version: 1.0
In-Reply-To: <20180115103220.g3xtdsybkfxqkapx@quack2.suse.cz>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571805555.27429.728109914195885407.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180115103220.g3xtdsybkfxqkapx@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Jan 2018 09:49:21 -0800
Message-ID: <CAPcyv4gVvhuCvnWL2jViZPdA5dAfQKZdiUi1-akpP3EazgY5qQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 13/19] udf: prevent bounds-check bypass via speculative execution
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Jan Kara <jack@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 15, 2018 at 2:32 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 11-01-18 16:47:35, Dan Williams wrote:
>> Static analysis reports that 'eahd->appAttrLocation' and
>> 'eahd->impAttrLocation' may be a user controlled values that are used as
>> data dependencies for calculating source and destination buffers for
>> memmove operations. In order to avoid potential leaks of kernel memory
>> values, block speculative execution of the instruction stream that could
>> issue further reads based on invalid 'aal' or 'ial' values.
>>
>> Based on an original patch by Elena Reshetova.
>>
>> Cc: Jan Kara <jack@suse.com>
>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Dan, I've already emailed to you [1] why I don't think this patch is needed
> at all. Do you disagree or did my email just get lost?
>
> [1] https://marc.info/?l=linux-arch&m=151540683024125&w=2

Sorry, I missed that one before the v2 posting went out. I've dropped
this from the v3 [1] posting.

[1]: https://marc.info/?l=linux-kernel&m=151586794400997&w=2
