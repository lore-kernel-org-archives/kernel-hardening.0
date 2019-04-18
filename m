Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot
 option
References: <20190418154208.131118-1-glider@google.com>
 <20190418154208.131118-2-glider@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <981d439a-1107-2730-f27e-17635ee4a125@intel.com>
Date: Thu, 18 Apr 2019 09:35:32 -0700
MIME-Version: 1.0
In-Reply-To: <20190418154208.131118-2-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org, cl@linux.com, dvyukov@google.com, keescook@chromium.org, labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 4/18/19 8:42 AM, Alexander Potapenko wrote:
> This option adds the possibility to initialize newly allocated pages and
> heap objects with zeroes. This is needed to prevent possible information
> leaks and make the control-flow bugs that depend on uninitialized values
> more deterministic.

Isn't it better to do this at free time rather than allocation time?  If
doing it at free, you can't even have information leaks for pages that
are in the allocator.
