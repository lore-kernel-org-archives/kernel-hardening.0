Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 22 Jun 2016 12:47:07 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160622124707.GC9922@io.lakedaemon.net>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
Subject: Re: [kernel-hardening] [PATCH v7 0/9] x86/mm: memory area address
 KASLR
To: kernel-hardening@lists.openwall.com
Cc: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hey Kees,

On Tue, Jun 21, 2016 at 05:46:57PM -0700, Kees Cook wrote:
> Notable problems that needed solving:
...
>  - Reasonable entropy is needed early at boot before get_random_bytes()
>    is available.

This series is targetting x86, which typically has RDRAND/RDSEED
instructions.  Are you referring to other arches?  Older x86?  Also,
isn't this the same requirement for base address KASLR?

Don't get me wrong, I want more diverse entropy sources available
earlier in the boot process as well. :-)  I'm just wondering what's
different about this series vs base address KASLR wrt early entropy
sources.

thx,

Jason.
