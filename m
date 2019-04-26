Date: Fri, 26 Apr 2019 15:24:24 +0000
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot
 option
In-Reply-To: <alpine.DEB.2.21.1904260911570.8340@nuc-kabylake>
Message-ID: <0100016a5a3f6121-e7ed483e-bc29-4d75-bd0a-8e3b973529f5-000000@email.amazonses.com>
References: <20190418154208.131118-1-glider@google.com> <20190418154208.131118-2-glider@google.com> <alpine.DEB.2.21.1904260911570.8340@nuc-kabylake>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, dvyukov@google.com, keescook@chromium.org, labbott@redhat.com, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hmmmm.... Maybe its better to zero on free? That way you dont need to
initialize the allocations. You could even check if someone mucked with
the object during allocation. This is a replication of some of the
inherent debugging facilities in the allocator though.
