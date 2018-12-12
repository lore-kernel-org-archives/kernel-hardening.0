From: Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH v2 2/4] modules: Add new special vfree flags
Date: Wed, 12 Dec 2018 23:40:25 +0000
Message-ID: <3AD9DBCA-C6EC-4FA6-84DC-09F3D4A9C47B@vmware.com>
References: <20181212000354.31955-1-rick.p.edgecombe@intel.com>
 <20181212000354.31955-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20181212000354.31955-3-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ADD48BCB096691449093B6E0F0AE63DE@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Will Deacon <will.deacon@arm.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jessica Yu <jeyu@kernel.org>, Network Development <netdev@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, "deneen.t.dock@intel.com" <deneen.t.dock@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Dec 11, 2018, at 4:03 PM, Rick Edgecombe <rick.p.edgecombe@intel.com> =
wrote:
>=20
> Add new flags for handling freeing of special permissioned memory in vmal=
loc,
> and remove places where the handling was done in module.c.
>=20
> This will enable this flag for all architectures.
>=20
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> kernel/module.c | 43 ++++++++++++-------------------------------
> 1 file changed, 12 insertions(+), 31 deletions(-)
>=20

I count on you for merging your patch-set with mine, since clearly they
conflict.
