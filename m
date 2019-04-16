Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
References: <20190412124501.132678-1-glider@google.com>
 <20190415190213.5831bbc17e5073690713b001@linux-foundation.org>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <f4071ce4-3744-35c9-df22-cb0a9d8db8ba@suse.cz>
Date: Tue, 16 Apr 2019 10:33:32 +0200
MIME-Version: 1.0
In-Reply-To: <20190415190213.5831bbc17e5073690713b001@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, labbott@redhat.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 4/16/19 4:02 AM, Andrew Morton wrote:
> Requiring a kernel rebuild is rather user-hostile.  A boot option
> (early_param()) would be much more useful and I expect that the loss in
> coverage would be small and acceptable?  Could possibly use the
> static_branch infrastructure.

Agreed. There could be a config option to make it default on if no param
given. Then a config option to (not) compile this in at all would be
probably superfluous, although small systems/architectures without
effective static keys might care.
