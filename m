Subject: Re: [PATCH 2/3] gfp: mm: introduce __GFP_NOINIT
References: <20190418154208.131118-1-glider@google.com>
 <20190418154208.131118-3-glider@google.com>
 <7bf6bd62-c8e0-df3d-8e98-70063f2d175a@intel.com>
 <CAGXu5j+Lm0ba4ZQ91vZ8nZFvpJSxu_j_bEKMaa0NMsurmyZjjA@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <2c66e43f-81d5-ebeb-495a-f3f3b65d315c@intel.com>
Date: Tue, 23 Apr 2019 13:40:19 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+Lm0ba4ZQ91vZ8nZFvpJSxu_j_bEKMaa0NMsurmyZjjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Dmitry Vyukov <dvyukov@google.com>, Laura Abbott <labbott@redhat.com>, Linux-MM <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 4/23/19 12:14 PM, Kees Cook wrote:
>> These sl*b ones seem like a bad idea.  We already have rules that sl*b
>> allocations must be initialized by callers, and we have reasonably
>> frequent bugs where the rules are broken.
> 
> Hm? No, this is saying that the page allocator can skip the auto-init
> because the slab internals will be doing it later.

Ahhh, got it.  I missed all the fun in patch 1.
