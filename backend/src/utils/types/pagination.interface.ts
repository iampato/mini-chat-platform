export interface IPagination<T = any> {
  data: T;
  metadata: {
    totalItems: number;
    perPage: number;
    page: number;
    lastPage: number;
  };
}
