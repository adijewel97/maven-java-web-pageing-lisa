package com.example.dto;

import java.util.List;
import java.util.Map;

public class DataTableDetailPgsResult {

    private List<Map<String, Object>> data;
    private List<Map<String, Object>> meta;
    private int totalItems;

    public List<Map<String, Object>> getData() {
        return data;
    }

    public void setData(List<Map<String, Object>> data) {
        this.data = data;
    }

    public List<Map<String, Object>> getMeta() {
        return meta;
    }

    public void setMeta(List<Map<String, Object>> meta) {
        this.meta = meta;
    }

    public int getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }
}
